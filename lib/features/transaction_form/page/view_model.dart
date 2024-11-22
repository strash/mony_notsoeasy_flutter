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

  TransactionFormVO({
    required this.transactionVO,
    required this.tags,
  });
}

final class TransactionFormViewModelBuilder extends StatefulWidget {
  final TransactionModel? transaction;
  final AccountModel? account;

  const TransactionFormViewModelBuilder({
    super.key,
    this.transaction,
    this.account,
  });

  @override
  ViewModelState<TransactionFormViewModelBuilder> createState() =>
      TransactionFormViewModel();
}

final class TransactionFormViewModel
    extends ViewModelState<TransactionFormViewModelBuilder> {
  TransactionModel? get transaction => widget.transaction;
  AccountModel? get account => widget.account;

  late final typeController = TabGroupController(
    transaction?.category.transactionType ?? ETransactionType.defaultValue,
  );

  late final dateController =
      CalendarController(transaction?.date ?? DateTime.now());
  late final timeController =
      TimeController(transaction?.date ?? DateTime.now());

  late final ValueNotifier<String> amountNotifier;

  late final accountController =
      SelectController<AccountModel?>(transaction?.account);

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
  final bottomSheetTagScrollController = ScrollController();

  late final noteInput = InputController()..text = transaction?.note ?? "";

  List<AccountModel> accounts = [];
  Map<ETransactionType, List<CategoryModel>> categories = {
    for (final key in ETransactionType.values) key: const [],
  };
  final displayedTags = ValueNotifier<List<TagModel>>([]);
  List<TransactionTagVariant> attachedTags = const [];

  bool isKeyboardHintAccepted = false;

  final RegExp regEx = RegExp(r"\d*?[.,]\d{2}$");
  List<List<TransactionFormButtonType>> get buttons {
    return List<List<TransactionFormButtonType>>.generate(3, (rowIndex) {
      return List<TransactionFormButtonType>.generate(3, (colIndex) {
        return TransactionFormButtonTypeSymbol(
          value: (colIndex + 1 + rowIndex * 3).toString(),
          color: Theme.of(context).colorScheme.surfaceContainer,
          isEnabled: (value) {
            final trim = value.trim();
            return !regEx.hasMatch(trim) && trim.length != kMaxAmountLength;
          },
        );
      });
    })
      ..add([
        TransactionFormButtonTypeSymbol(
          value: ".",
          color: Theme.of(context).colorScheme.surfaceContainer,
          isEnabled: (value) {
            final trim = value.trim();
            return !trim.contains(".") && trim.length != kMaxAmountLength;
          },
        ),
        TransactionFormButtonTypeSymbol(
          value: "0",
          color: Theme.of(context).colorScheme.surfaceContainer,
          isEnabled: (value) {
            final trim = value.trim();
            return !regEx.hasMatch(trim) && trim.length != kMaxAmountLength;
          },
        ),
        TransactionFormButtonTypeAction(
          icon: Assets.icons.checkmarkBold,
          color: Theme.of(context).colorScheme.secondary,
          isEnabled: (value) {
            final trim = value.trim();
            final hasCategory = switch (typeController.value) {
              ETransactionType.expense =>
                expenseCategoryController.value != null,
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
    final formatter = DateFormat("d MMM yyyy, HH:mm");
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

  String get amountDescription {
    final formatter = NumberFormat.decimalPattern();
    final parsedValue = double.parse(amountNotifier.value);
    final formattedValue = formatter.format(parsedValue);
    if (amountNotifier.value.endsWith(".")) {
      return "$formattedValue.";
    } else if (amountNotifier.value.endsWith(".0")) {
      return "$formattedValue.0";
    } else if (amountNotifier.value.endsWith(".00")) {
      return "$formattedValue.00";
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
    OnInitData().call(context, this);
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
        () => OnDatePressed(),
        () => OnAddTagPressed(),
        () => OnRemoveTagPressed(),
        () => OnNotePressed(),
        () => OnKeyboardHintAccepted(),
        () => OnKeyPressed(),
        () => OnHorizontalDragEnded(),
      ],
      child: const TransactionFormView(),
    );
  }
}
