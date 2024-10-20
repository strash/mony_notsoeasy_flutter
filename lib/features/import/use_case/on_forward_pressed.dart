import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/features/import/validator/validator.dart";

final class OnForwardPressed extends UseCase<Future<void>, ImportEvent?> {
  @override
  Future<void> call(BuildContext context, [ImportEvent? event]) async {
    if (event == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<ImportViewModel>();
    final subject = viewModel.subject;
    switch (event) {
      case ImportEventCsvLoaded():
        subject.add(ImportEventMappingColumns());
        viewModel.setProtectedState(() {
          viewModel.mappedColumns = List.from(
            viewModel.mappedColumns
              ..add((column: EImportColumn.defaultValue, entryKey: null)),
          );
          viewModel.currentColumn = EImportColumn.defaultValue;
        });
      case ImportEventMappingColumns():
        final nextCol = EImportColumn.from(viewModel.mappedColumns.length);
        if (nextCol == null) {
          subject.add(ImportEventValidatingMappedColumns());
          viewModel.columnValidationResults.length = 0;
          if (viewModel.csv == null) break;
          for (final column in viewModel.mappedColumns) {
            await Future.delayed(const Duration(milliseconds: 400));
            final entryKey = column.entryKey;
            if (entryKey == null) continue;
            final validator = switch (column.column) {
              EImportColumn.account => AccountValidator(),
              EImportColumn.amount => AmountValidator(),
              EImportColumn.expenseType => ExpenseTypeValidator(),
              EImportColumn.date => DateValidator(),
              EImportColumn.category => CategoryValidator(),
              EImportColumn.tag => TagValidator(),
              EImportColumn.note => NoteValidator(),
            };
            final result = validator.validate(viewModel.csv!.entries, entryKey);
            viewModel.setProtectedState(() {
              viewModel.columnValidationResults.add(result);
            });
          }
          if (viewModel.columnValidationResults.any((e) => e.error != null)) {
            subject.add(ImportEventErrorMappingColumns());
          } else {
            subject.add(ImportEventMappingColumnsValidated());
          }
        } else {
          viewModel.setProtectedState(() {
            viewModel.mappedColumns = List.from(
              viewModel.mappedColumns..add((column: nextCol, entryKey: null)),
            );
            viewModel.currentColumn = nextCol;
          });
        }
      case ImportEventMappingColumnsValidated():
      // TODO: next step
      case ImportEventInitial() ||
            ImportEventLoadingCsv() ||
            ImportEventErrorLoadingCsv() ||
            ImportEventValidatingMappedColumns() ||
            ImportEventErrorMappingColumns():
        break;
    }
    viewModel.setProtectedState(() {
      viewModel.progress++;
    });
  }
}
