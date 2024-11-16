import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/import/page/page.dart";

final class OnBackwardPressed extends UseCase<Future<void>, ImportEvent?> {
  @override
  Future<void> call(BuildContext context, [ImportEvent? event]) async {
    if (event == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<ImportViewModel>();
    final subject = viewModel.subject;
    // go back
    switch (event) {
      case ImportEventInitial() ||
            ImportEventLoadingCsv() ||
            ImportEventErrorLoadingCsv() ||
            ImportEventToDb():
        return;
      case ImportEventMappingColumns():
        _removeLastStep(viewModel);
        if (viewModel.currentStep is ImportModelCsv) {
          subject.add(ImportEventInitial());
        }
      case ImportEventValidatingMappedColumns() ||
            ImportEventErrorMappingColumns() ||
            ImportEventMappingColumnsValidated():
        _removeLastStep(viewModel);
        subject.add(ImportEventMappingColumns());
      case ImportEventMapAccounts():
        _removeLastStep(viewModel);
        subject.add(ImportEventMappingColumnsValidated());
      case ImportEventMapTransactionType():
        _removeLastStep(viewModel);
        subject.add(ImportEventMapAccounts());
        viewModel.setProtectedState(() {
          viewModel.additionalSteps--;
          viewModel.mappedTransactionTypeExpense = null;
          viewModel.mappedTransactionTypeIncome = null;
          viewModel.transactionTypeDecisionController.value =
              ETypeDecision.isExpense;
        });
      case ImportEventMapCategories():
        if (viewModel.hasMappedTransactionTypeColumn) {
          subject.add(ImportEventMapTransactionType());
        } else {
          subject.add(ImportEventMapAccounts());
        }
        viewModel.setProtectedState(() {
          viewModel.mappedCategories[ETransactionType.expense] = const [];
          viewModel.mappedCategories[ETransactionType.income] = const [];
        });
    }
    print(viewModel.steps);
  }

  void _removeLastStep(ImportViewModel viewModel) {
    if (viewModel.steps.lastOrNull == null) return;
    viewModel.setProtectedState(() {
      viewModel.currentStep.dispose();
      viewModel.currentStep = viewModel.steps.last;
      viewModel.steps = List<ImportModel>.from(viewModel.steps..removeLast());
    });
  }
}
