import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/features/import/import.dart";

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
        _stepBack(viewModel);
        if (viewModel.currentStep is ImportModelCsv) {
          subject.add(ImportEventInitial());
        }
      case ImportEventValidatingMappedColumns() ||
            ImportEventErrorMappingColumns() ||
            ImportEventMappingColumnsValidated():
        _stepBack(viewModel);
        subject.add(ImportEventMappingColumns());
      case ImportEventMapAccounts():
        _stepBack(viewModel);
        subject.add(ImportEventMappingColumnsValidated());
      case ImportEventMapTransactionType():
        _stepBack(viewModel);
        subject.add(ImportEventMapAccounts());
        viewModel.setProtectedState(() {
          viewModel.additionalSteps--;
          viewModel.transactionTypeController.value = ETransactionType.expense;
        });
      case ImportEventMapCategories():
        final validation = viewModel.steps
            .whereType<ImportModelColumnValidation>()
            .firstOrNull;
        if (validation == null) throw ArgumentError.notNull();
        if (validation.mappedColumns
            .any((e) => e.column == EImportColumn.transactionType)) {
          _stepBack(viewModel);
          subject.add(ImportEventMapTransactionType());
        } else {
          _stepBack(viewModel);
          _stepBack(viewModel);
          subject.add(ImportEventMapAccounts());
        }
    }
  }

  void _stepBack(ImportViewModel viewModel) {
    if (viewModel.steps.lastOrNull == null) return;
    viewModel.setProtectedState(() {
      viewModel.currentStep.dispose();
      viewModel.currentStep = viewModel.steps.last;
      viewModel.steps = List<ImportModel>.from(viewModel.steps..removeLast());
    });
  }
}
