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
        viewModel.setProtectedState(() {
          if (viewModel.mappedColumns.isNotEmpty) {
            viewModel.mappedColumns = List.from(
              viewModel.mappedColumns..removeLast(),
            );
          }
          viewModel.currentColumn = viewModel.mappedColumns.lastOrNull?.column;
        });
        if (viewModel.mappedColumns.isEmpty) {
          subject.add(ImportEventInitial());
        }
      case ImportEventValidatingMappedColumns() ||
            ImportEventErrorMappingColumns() ||
            ImportEventMappingColumnsValidated():
        subject.add(ImportEventMappingColumns());
      case ImportEventMapAccounts():
        subject.add(ImportEventMappingColumnsValidated());
      case ImportEventMapTransactionType():
        subject.add(ImportEventMapAccounts());
        viewModel.setProtectedState(() {
          viewModel.additionalSteps--;
          viewModel.mappedTransactionTypeExpense = null;
          viewModel.mappedTransactionTypeIncome = null;
          viewModel.isTransactionsExpenses = true;
        });
      case ImportEventMapCategories():
        if (viewModel.hasMappedTransactionType) {
          subject.add(ImportEventMapTransactionType());
        } else {
          subject.add(ImportEventMapAccounts());
        }
        viewModel.setProtectedState(() {
          viewModel.mappedCategories[ETransactionType.expense] = const [];
          viewModel.mappedCategories[ETransactionType.income] = const [];
        });
    }
    viewModel.setProtectedState(() {
      viewModel.progress--;
    });
  }
}