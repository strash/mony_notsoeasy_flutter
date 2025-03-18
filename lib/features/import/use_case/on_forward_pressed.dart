import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/features/import/use_case/use_case.dart";

final class OnForwardPressed extends UseCase<Future<void>, ImportEvent?> {
  @override
  Future<void> call(BuildContext context, [ImportEvent? event]) async {
    if (event == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<ImportViewModel>();
    switch (event) {
      case ImportEventMappingColumns():
        _onMappingColumns(viewModel);
      case ImportEventMappingColumnsValidated():
        _onColumnsValidated(viewModel);
      case ImportEventMapAccounts():
        _onAccountsMapped(viewModel, context.service<DomainCategoryService>());
      case ImportEventMapTransactionType():
        _onTransactionTypesMapped(
          viewModel,
          context.service<DomainCategoryService>(),
        );
      case ImportEventMapCategories():
        _onCategoriesMapped(context);
      case ImportEventInitial() ||
          ImportEventLoadingCsv() ||
          ImportEventErrorLoadingCsv() ||
          ImportEventValidatingMappedColumns() ||
          ImportEventErrorMappingColumns() ||
          ImportEventToDb():
        break;
    }
  }

  Future<void> _onMappingColumns(ImportViewModel viewModel) async {
    if (viewModel.currentStep is! ImportModelColumn) return;
    final currentColumn = viewModel.currentStep as ImportModelColumn;
    final subject = viewModel.subject;
    final nextCol = currentColumn.column.next;
    if (nextCol == null) {
      final csv = viewModel.steps.whereType<ImportModelCsv>().firstOrNull;
      if (csv == null) throw ArgumentError.notNull();
      subject.add(ImportEventValidatingMappedColumns());
      viewModel.setProtectedState(() {
        viewModel.steps = List<ImportModel>.from(viewModel.steps)
          ..add(currentColumn);
      });
      final validation = ImportModelColumnValidation(
        csvModel: csv,
        columns: viewModel.mappedColumns,
      );
      viewModel.setProtectedState(() {
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
        viewModel.currentStep = ImportModelColumn(
          column: nextCol,
          columnKey: null,
        );
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
    final accountColumn =
        validation.mappedColumns.where((e) {
          return e.column == EImportColumn.account;
        }).firstOrNull;
    // single required account
    if (accountColumn == null || accountColumn.columnKey == null) {
      viewModel.setProtectedState(() {
        accountModel.accounts = [
          ImportModelAccountVO(originalTitle: null, account: null),
        ];
      });
      // accounts from the data
    } else {
      final Set<String> accounts = {};
      for (final element in validation.mappedEntries) {
        for (final MapEntry(:key, :value) in element.entries) {
          if (key.column == EImportColumn.account) accounts.add(value);
        }
      }
      viewModel.setProtectedState(() {
        accountModel.accounts = accounts
            .map((e) {
              return ImportModelAccountVO(originalTitle: e, account: null);
            })
            .toList(growable: false);
      });
    }
  }

  void _onAccountsMapped(
    ImportViewModel viewModel,
    DomainCategoryService categoryService,
  ) {
    final accountModel = viewModel.currentStep;
    if (accountModel is! ImportModelAccount) {
      throw ArgumentError.value(accountModel);
    }
    final validation =
        viewModel.steps.whereType<ImportModelColumnValidation>().firstOrNull;
    if (validation == null) throw ArgumentError.notNull();
    final hasMappedTransactionType = validation.mappedColumns.any(
      (e) => e.column == EImportColumn.transactionType,
    );
    final typeModel = ImportModelTransactionType(validation: validation);
    // NOTE: setting type model anyway
    viewModel.setProtectedState(() {
      viewModel.steps = List<ImportModel>.from(viewModel.steps)
        ..add(accountModel);
      viewModel.currentStep = typeModel;
    });
    if (hasMappedTransactionType) {
      typeModel.remap(typeModel.largest.typeValue, ETransactionType.expense);
      viewModel.subject.add(ImportEventMapTransactionType());
      viewModel.setProtectedState(() => viewModel.additionalSteps++);
    } else {
      _onTransactionTypesMapped(viewModel, categoryService);
    }
  }

  Future<void> _onTransactionTypesMapped(
    ImportViewModel viewModel,
    DomainCategoryService categoryService,
  ) async {
    final typeModel = viewModel.currentStep;
    if (typeModel is! ImportModelTransactionType) {
      throw ArgumentError.value(typeModel);
    }
    final categoryModel = ImportModelCategory(typeModel: typeModel);
    // load built-in categories
    final categories = await Future.wait(
      ETransactionType.values.map((e) {
        return categoryService.getAll(transactionType: e);
      }),
    );
    viewModel.subject.add(ImportEventMapCategories());
    viewModel.setProtectedState(() {
      viewModel.steps = List<ImportModel>.from(viewModel.steps)..add(typeModel);
      viewModel.currentStep = categoryModel;
      viewModel.categoryModels = {
        for (final (index, value) in ETransactionType.values.indexed)
          value: categories.elementAt(index),
      };
    });
  }

  void _onCategoriesMapped(BuildContext context) {
    final viewModel = context.viewModel<ImportViewModel>();
    final categoryModel = viewModel.currentStep;
    if (categoryModel is! ImportModelCategory) {
      throw ArgumentError.value(categoryModel);
    }
    viewModel.subject.add(ImportEventToDb());
    viewModel.setProtectedState(() {
      viewModel.steps = List<ImportModel>.from(viewModel.steps)
        ..add(categoryModel);
    });
    viewModel<OnDoneMapping>().call(context);
  }
}
