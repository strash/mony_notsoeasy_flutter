import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/calendar/component.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/components/time/component.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/transaction_form/components/keyboard_button_type.dart";
import "package:mony_app/features/transaction_form/page/view.dart";
import "package:mony_app/features/transaction_form/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

final class TransactionFormVO {
  final TransactionVO transactionVO;
  final List<TransactionTagVariant> tags;

  TransactionFormVO({required this.transactionVO, required this.tags});
}

final class TransactionFormPage extends StatefulWidget {
  final TransactionModel? transaction;
  final AccountModel? account;

  const TransactionFormPage({super.key, this.transaction, this.account});

  @override
  ViewModelState<TransactionFormPage> createState() =>
      TransactionFormViewModel();
}

// при создании новой транзакции
final class TransactionFormViewModel
    extends ViewModelState<TransactionFormPage> {
  bool isColorsVisible = true;

  TransactionModel? get transaction => widget.transaction;
  AccountModel? get account => widget.account;

  late final typeController = TabGroupController(
    transaction?.category.transactionType ?? ETransactionType.defaultValue,
  );

  late final dateController = CalendarController(
    transaction?.date ?? DateTime.now(),
  );
  late final timeController = TimeController(
    transaction?.date ?? DateTime.now(),
  );

  late final ValueNotifier<String> amountNotifier;

  late final accountController = SelectController<AccountModel?>(
    transaction?.account,
  );

  late final expenseCategoryController = SelectController<CategoryModel?>(
    transaction?.category.transactionType == ETransactionType.expense
        ? transaction?.category
        : null,
  );
  late final incomeCategoryController = SelectController<CategoryModel?>(
    transaction?.category.transactionType == ETransactionType.income
        ? transaction?.category
        : null,
  );

  final tagScrollController = ScrollController();
  final tagInput = InputController();
  final bottomSheetTagScrollController = FeedScrollController();

  late final noteInput = InputController()..text = transaction?.note ?? "";

  List<AccountModel> accounts = [];
  Map<ETransactionType, List<CategoryModel>> categories = {
    for (final key in ETransactionType.values) key: const [],
  };
  final displayedTags = ValueNotifier<List<TagModel>>([]);
  List<TransactionTagVariant> attachedTags = const [];

  bool isKeyboardHintAccepted = true;
  String decimalSeparator = ".";
  Offset dragStartPosition = Offset.zero;

  final RegExp regEx = RegExp(kNewTransactionAmountPattern);

  List<List<TransactionFormButtonType>> get buttons {
    return List<List<TransactionFormButtonType>>.generate(3, (rowIndex) {
      return List<TransactionFormButtonType>.generate(3, (colIndex) {
        final value = (colIndex + 1 + rowIndex * 3).toString();

        return TransactionFormButtonTypeSymbol(
          value: value,
          displayedValue: value,
          color: ColorScheme.of(context).surfaceContainer,
          isEnabled: (newValue) {
            final trim = newValue.trim();
            return !regEx.hasMatch(trim) && trim.length != kMaxAmountLength;
          },
        );
      });
    })..add([
      TransactionFormButtonTypeSymbol(
        value: ".",
        displayedValue: decimalSeparator,
        color: ColorScheme.of(context).surfaceContainer,
        isEnabled: (value) {
          final trim = value.trim();
          return !trim.contains(".") && trim.length != kMaxAmountLength;
        },
      ),
      TransactionFormButtonTypeSymbol(
        value: "0",
        displayedValue: "0",
        color: ColorScheme.of(context).surfaceContainer,
        isEnabled: (value) {
          final trim = value.trim();
          return !regEx.hasMatch(trim) && trim.length != kMaxAmountLength;
        },
      ),
      TransactionFormButtonTypeAction(
        icon: Assets.icons.checkmarkBold,
        color: ColorScheme.of(context).secondary,
        isEnabled: (value) {
          final trim = value.trim();
          final hasCategory = switch (typeController.value) {
            ETransactionType.expense => expenseCategoryController.value != null,
            ETransactionType.income => incomeCategoryController.value != null,
          };
          return trim.isNotEmpty &&
              trim != "0" &&
              accountController.value != null &&
              hasCategory;
        },
      ),
    ]);
  }

  String get dateTimeDescription {
    final locale = Localizations.localeOf(context);
    final formatter = DateFormat("d MMM yyyy, HH:mm", locale.languageCode);
    final date = DateTime(
      dateController.value!.year,
      dateController.value!.month,
      dateController.value!.day,
      timeController.value.hour,
      timeController.value.minute,
      dateController.value!.second,
    );
    return formatter.format(date);
  }

  String amountDescription(String locale) {
    final formatter = NumberFormat.decimalPattern(locale);
    final parsedValue = double.parse(amountNotifier.value);
    final formattedValue = formatter.format(parsedValue);
    if (amountNotifier.value.endsWith(".")) {
      return "$formattedValue$decimalSeparator";
    } else if (amountNotifier.value.endsWith(".0")) {
      return "$formattedValue${decimalSeparator}0";
    } else if (amountNotifier.value.endsWith(".00")) {
      return "$formattedValue${decimalSeparator}00";
    } else {
      return formattedValue;
    }
  }

  @override
  void initState() {
    super.initState();

    final amount = transaction?.amount.abs() ?? .0;
    final hasFraction = amount.hasFraction;
    amountNotifier = ValueNotifier<String>(
      (hasFraction ? amount.roundToFraction(2) : amount.toInt()).toString(),
    );

    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      final locale = Localizations.localeOf(context);
      final formatter = NumberFormat.decimalPattern(locale.languageCode);
      decimalSeparator = formatter.symbols.DECIMAL_SEP;

      final sharedPrefService =
          context.service<DomainSharedPreferencesService>();
      final hint =
          await sharedPrefService.isNewTransactionKeyboardHintAccepted();
      final colors = await sharedPrefService.isSettingsColorsVisible();
      final transactionType =
          await sharedPrefService.getSettingsDefaultTransactionType();
      setProtectedState(() {
        isKeyboardHintAccepted = hint;
        isColorsVisible = colors;
        if (transaction == null) typeController.value = transactionType;
      });

      if (!mounted) return;
      OnInit().call(context, this);
    });
  }

  @override
  void dispose() {
    typeController.dispose();

    dateController.dispose();
    timeController.dispose();

    amountNotifier.dispose();

    accountController.dispose();

    expenseCategoryController.dispose();
    incomeCategoryController.dispose();

    tagScrollController.dispose();
    tagInput.dispose();
    displayedTags.dispose();
    bottomSheetTagScrollController.dispose();

    noteInput.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<TransactionFormViewModel>(
      viewModel: this,
      useCases: [
        () => OnInfoPressed(),
        () => OnDatePressed(),
        () => OnAddTagPressed(),
        () => OnRemoveTagPressed(),
        () => OnNotePressed(),
        () => OnKeyboardHintAccepted(),
        () => OnKeyPressed(),
        () => OnHorizontalDragStarted(),
        () => OnHorizontalDragEnded(),
      ],
      child: const TransactionFormView(),
    );
  }
}
