import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/features/import/validator/validator.dart";

final class OnForwardPressed extends UseCase<Future<void>, ImportEvent?> {
  void _onCsvLoaded(ImportViewModel viewModel) {
    final subject = viewModel.subject;
    subject.add(ImportEventMappingColumns());
    viewModel.setProtectedState(() {
      viewModel.mappedColumns = List.from(
        viewModel.mappedColumns
          ..add((column: EImportColumn.defaultValue, entryKey: null)),
      );
      viewModel.currentColumn = EImportColumn.defaultValue;
    });
  }

  Future<void> _onMappingColumns(ImportViewModel viewModel) async {
    final subject = viewModel.subject;
    final nextCol = EImportColumn.from(viewModel.mappedColumns.length);
    if (nextCol == null) {
      subject.add(ImportEventValidatingMappedColumns());
      viewModel.columnValidationResults.length = 0;
      if (viewModel.csv == null) return;
      for (final column in viewModel.mappedColumns) {
        await Future.delayed(const Duration(milliseconds: 300));
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
  }

  void _onColumnsValidated(ImportViewModel viewModel) {
    final subject = viewModel.subject;
    viewModel.setProtectedState(() => viewModel.accounts = {});
    subject.add(ImportEventMapAccounts());
    final accountColumn = viewModel.mappedColumns.where((e) {
      return e.column == EImportColumn.account;
    }).firstOrNull;
    if (accountColumn == null ||
        accountColumn.entryKey == null ||
        viewModel.csv == null) return;
    final Set<String> accounts = {};
    for (final element in viewModel.csv!.entries) {
      final value = element[accountColumn.entryKey!];
      if (value == null) continue;
      accounts.add(value);
    }
    viewModel.setProtectedState(() {
      for (final account in accounts) {
        viewModel.accounts[account] = null;
      }
    });
  }

  @override
  Future<void> call(BuildContext context, [ImportEvent? event]) async {
    if (event == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<ImportViewModel>();
    switch (event) {
      case ImportEventCsvLoaded():
        _onCsvLoaded(viewModel);
      case ImportEventMappingColumns():
        await _onMappingColumns(viewModel);
      case ImportEventMappingColumnsValidated():
        _onColumnsValidated(viewModel);
      case ImportEventMapAccounts():
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
