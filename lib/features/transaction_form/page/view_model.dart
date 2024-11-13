import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/calendar/component.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/components/time/component.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/transaction_form/components/keyboard_button_type.dart";
import "package:mony_app/features/transaction_form/page/view.dart";
import "package:mony_app/gen/assets.gen.dart";

export "../use_case/use_case.dart";
export "./tag_vo.dart";

final class TransactionFormViewModelBuilder extends StatefulWidget {
  const TransactionFormViewModelBuilder({super.key});

  @override
  ViewModelState<TransactionFormViewModelBuilder> createState() =>
      TransactionFormViewModel();
}

final class TransactionFormViewModel
    extends ViewModelState<TransactionFormViewModelBuilder> {
  final typeController = TabGroupController(ETransactionType.defaultValue);

  final dateController = CalendarController(DateTime.now());
  final timeController = TimeController(DateTime.now());

  final amountNotifier = ValueNotifier<String>("0");

  final accountController = SelectController<AccountModel?>(null);

  final expenseCategoryController = SelectController<CategoryModel?>(null);
  final incomeCategoryController = SelectController<CategoryModel?>(null);

  final tagScrollController = ScrollController();
  final tagInput = InputController();
  final bottomSheetTagScrollController = ScrollController();

  final noteInput = InputController();

  List<AccountModel> accounts = [];
  Map<ETransactionType, List<CategoryModel>> categories = {
    for (final key in ETransactionType.values) key: const [],
  };
  final displayedTags = ValueNotifier<List<TagModel>>([]);
  List<TransactionFormTag> attachedTags = const [];

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
