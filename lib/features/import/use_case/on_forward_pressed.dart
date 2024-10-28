import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/import/import.dart";
import "package:provider/provider.dart";

final class OnForwardPressed extends UseCase<Future<void>, ImportEvent?> {
  Future<void> _onMappingColumns(ImportViewModel viewModel) async {
    final subject = viewModel.subject;
    final nextCol = EImportColumn.from(viewModel.mappedColumns.length);
    if (nextCol == null) {
      subject.add(ImportEventValidatingMappedColumns());
      viewModel.columnValidationResults.length = 0;
      if (viewModel.csv == null) return;
      for (final column in viewModel.mappedColumns) {
        await Future.delayed(const Duration(milliseconds: 150));
        final entryKey = column.entryKey;
        if (entryKey == null) continue;
        final validator = switch (column.column) {
          EImportColumn.account => AccountValidator(),
          EImportColumn.amount => AmountValidator(),
          EImportColumn.transactionType => TransactionTypeValidator(),
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
    viewModel.setProtectedState(() {
      viewModel.singleAccount = null;
      viewModel.accounts = {};
    });
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

  void _onAccountsMapped(
    ImportViewModel viewModel,
    DomainCategoryService categoryService,
  ) {
    if (viewModel.hasMappedTransactionType) {
      viewModel.subject.add(ImportEventMapTransactionType());
      viewModel.setProtectedState(() {
        viewModel.additionalSteps++;
      });
      viewModel.mapTransactionTypes();
    } else {
      _onTransactionTypesMapped(viewModel, categoryService);
    }
  }

  Future<void> _onTransactionTypesMapped(
    ImportViewModel viewModel,
    DomainCategoryService categoryService,
  ) async {
    // group imported categories
    final implyTypeFromAmount = viewModel.mappedTransactionTypeExpense == null;
    final Set<String> importExp = {};
    final Set<String> importInc = {};
    for (final e in viewModel.csv!.entries) {
      String amount = "";
      String category = "";
      String? transactionType;
      for (final entry in e.entries) {
        final column = viewModel.getColumn(entry.key);
        switch (column) {
          case EImportColumn.category:
            category = entry.value;
          case EImportColumn.amount:
            amount = entry.value;
          case EImportColumn.transactionType:
            transactionType = entry.value;
          default:
            continue;
        }
      }
      if (implyTypeFromAmount) {
        if (double.parse(amount) < .0) {
          importExp.add(category);
        } else {
          importInc.add(category);
        }
      } else {
        if (transactionType == viewModel.mappedTransactionTypeExpense) {
          importExp.add(category);
        } else {
          importInc.add(category);
        }
      }
    }
    viewModel.setProtectedState(() {
      viewModel.mappedCategories[ETransactionType.expense] = importExp.map((e) {
        return (title: e, linkedModel: null, vo: null);
      }).toList();
      viewModel.mappedCategories[ETransactionType.income] = importInc.map((e) {
        return (title: e, linkedModel: null, vo: null);
      }).toList();
    });
    // load built-in categories
    final exp =
        await categoryService.getAll(transactionType: ETransactionType.expense);
    final inc =
        await categoryService.getAll(transactionType: ETransactionType.income);
    viewModel.subject.add(ImportEventMapCategories());
    viewModel.setProtectedState(() {
      viewModel.categoryModels[ETransactionType.expense] = exp;
      viewModel.categoryModels[ETransactionType.income] = inc;
    });
  }

  @override
  Future<void> call(BuildContext context, [ImportEvent? event]) async {
    if (event == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<ImportViewModel>();
    final categoryService = context.read<DomainCategoryService>();
    switch (event) {
      case ImportEventMappingColumns():
        await _onMappingColumns(viewModel);
      case ImportEventMappingColumnsValidated():
        _onColumnsValidated(viewModel);
      case ImportEventMapAccounts():
        _onAccountsMapped(viewModel, categoryService);
      case ImportEventMapTransactionType():
        _onTransactionTypesMapped(viewModel, categoryService);
      case ImportEventMapCategories():
        viewModel.subject.add(ImportEventToDb());
        viewModel<OnDoneMapping>().call(context);
      case ImportEventInitial() ||
            ImportEventLoadingCsv() ||
            ImportEventErrorLoadingCsv() ||
            ImportEventValidatingMappedColumns() ||
            ImportEventErrorMappingColumns() ||
            ImportEventToDb():
        break;
    }
    viewModel.setProtectedState(() {
      viewModel.progress++;
    });
  }
}
