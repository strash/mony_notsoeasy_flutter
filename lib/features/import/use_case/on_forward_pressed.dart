import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/import/import.dart";
import "package:provider/provider.dart";

final class OnForwardPressed extends UseCase<Future<void>, ImportEvent?> {
  Future<void> _onMappingColumns(ImportViewModel viewModel) async {
    if (viewModel.currentStep is! ImportModelColumn) return;
    final currentColumn = viewModel.currentStep as ImportModelColumn;
    final subject = viewModel.subject;
    final nextCol = currentColumn.column.next;
    if (nextCol == null) {
      final csv = viewModel.steps.whereType<ImportModelCsv>().firstOrNull;
      if (csv == null) throw ArgumentError.notNull();
      subject.add(ImportEventValidatingMappedColumns());
      final validation = ImportModelColumnValidation(
        csv: csv,
        columns: viewModel.columns,
      );
      viewModel.setProtectedState(() {
        viewModel.steps = List<ImportModel>.from(viewModel.steps)
          ..add(currentColumn);
        viewModel.currentStep = validation;
      });
      await validation.validate();
      if (validation.isReady()) {
        subject.add(ImportEventMappingColumnsValidated());
      } else {
        subject.add(ImportEventErrorMappingColumns());
      }
    } else {
      viewModel.setProtectedState(() {
        viewModel.steps = List<ImportModel>.from(viewModel.steps)
          ..add(currentColumn);
        viewModel.currentStep = ImportModelColumn(column: nextCol, value: null);
      });
    }
  }

  void _onColumnsValidated(ImportViewModel viewModel) {
    final subject = viewModel.subject;
    final validation = viewModel.currentStep;
    if (validation is! ImportModelColumnValidation) {
      throw ArgumentError.value(validation);
    }
    subject.add(ImportEventMapAccounts());
    final accountModel = ImportModelAccount();
    viewModel.setProtectedState(() {
      viewModel.steps = List<ImportModel>.from(viewModel.steps)
        ..add(validation);
      viewModel.currentStep = accountModel;
    });
    final accountColumn = validation.mappedColumns.where((e) {
      return e.column == EImportColumn.account;
    }).firstOrNull;
    // single required account
    if (accountColumn == null || accountColumn.value == null) {
      viewModel.setProtectedState(() {
        accountModel.accounts.value = [
          ImportModelAccountVO(originalTitle: null, account: null),
        ];
      });
      // accounts from the data
    } else {
      final Set<String> accounts = {};
      for (final element in validation.csv.csv!.entries) {
        final value = element[accountColumn.value!];
        if (value == null) continue;
        accounts.add(value);
      }
      viewModel.setProtectedState(() {
        accountModel.accounts.value = accounts.map((e) {
          return ImportModelAccountVO(originalTitle: e, account: null);
        }).toList(growable: false);
      });
    }
  }

  void _onAccountsMapped(
    ImportViewModel viewModel,
    DomainCategoryService categoryService,
  ) {
    if (viewModel.hasMappedTransactionTypeColumn) {
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
    final csv = viewModel.csv;
    if (csv == null) throw ArgumentError.notNull();
    for (final e in csv.entries) {
      String amount = "";
      String category = "";
      String? transactionType;
      for (final element in e.entries) {
        final column = viewModel.columns
            .where((e) => e.value == element.key)
            .firstOrNull
            ?.column;
        switch (column) {
          case EImportColumn.category:
            category = element.value;
          case EImportColumn.amount:
            amount = element.value;
          case EImportColumn.transactionType:
            transactionType = element.value;
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
    switch (event) {
      case ImportEventMappingColumns():
        await _onMappingColumns(viewModel);
      case ImportEventMappingColumnsValidated():
        _onColumnsValidated(viewModel);
      case ImportEventMapAccounts():
        _onAccountsMapped(viewModel, context.read<DomainCategoryService>());
      case ImportEventMapTransactionType():
        _onTransactionTypesMapped(
          viewModel,
          context.read<DomainCategoryService>(),
        );
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
    print(viewModel.steps);
  }
}
