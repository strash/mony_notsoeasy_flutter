import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/components/calendar/component.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/components/time/component.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/new_transaction/page/view.dart";

export "../use_case/use_case.dart";
export "./tag_vo.dart";

final class NewTransactionViewModelBuilder extends StatefulWidget {
  const NewTransactionViewModelBuilder({super.key});

  @override
  ViewModelState<NewTransactionViewModelBuilder> createState() =>
      NewTransactionViewModel();
}

final class NewTransactionViewModel
    extends ViewModelState<NewTransactionViewModelBuilder> {
  final typeController = TabGroupController(ETransactionType.defaultValue);
  final accountController = SelectController<AccountModel?>(null);
  final expenseCategoryController = SelectController<CategoryModel?>(null);
  final incomeCategoryController = SelectController<CategoryModel?>(null);
  final dateController = CalendarController(DateTime.now());
  final timeController = TimeController(DateTime.now());

  List<AccountModel> accounts = [];
  Map<ETransactionType, List<CategoryModel>> categories = {
    for (final key in ETransactionType.values) key: const [],
  };

  List<NewTransactionTag> attachedTags = [];

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

  @override
  void initState() {
    super.initState();
    OnInitData().call(context, this);
  }

  @override
  void dispose() {
    typeController.dispose();
    accountController.dispose();
    expenseCategoryController.dispose();
    incomeCategoryController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<NewTransactionViewModel>(
      viewModel: this,
      useCases: [
        () => OnDatePressed(),
      ],
      child: const NewTransactionView(),
    );
  }
}
