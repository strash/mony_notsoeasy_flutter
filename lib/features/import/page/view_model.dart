import "dart:math";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/descriptable/descriptable.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/features/import/page/view.dart";
import "package:rxdart/subjects.dart";

export "../use_case/use_case.dart";
export "../validator/validator.dart";

typedef TMappedColumn = ({EImportColumn column, String? entryKey});

typedef TTransactionsByType = ({
  List<Map<String, String>> entriesByType,
  Set<String> types,
});

// either a model is linked to a category or a new vo is created
typedef TMappedCategory = ({
  String title,
  CategoryModel? linkedModel,
  CategoryVO? vo,
});

typedef TPressedCategoryValue = ({
  ETransactionType transactionType,
  TMappedCategory category,
});

enum ETypeDecision implements IDescriptable {
  isExpense,
  isNotExpense,
  ;

  @override
  String get description {
    return switch (this) {
      ETypeDecision.isExpense => "Это расходы",
      ETypeDecision.isNotExpense => "Это доходы",
    };
  }
}

final class ImportViewModelBuilder extends StatefulWidget {
  const ImportViewModelBuilder({super.key});

  @override
  ViewModelState<ImportViewModelBuilder> createState() => ImportViewModel();
}

final class ImportViewModel extends ViewModelState<ImportViewModelBuilder> {
  final subject = BehaviorSubject<ImportEvent>.seeded(ImportEventInitial());

  // progress
  int progress = 0;

  int get progressPercentage {
    return (progress * 100 / max(1, _totalProgress + additionalSteps)).round();
  }

  final _totalProgress = 11;
  int additionalSteps = 0;

  // parsed csv

  ImportedCsvVO? csv;

  int currentEntryIndex = 0;

  Map<String, String>? get currentEntry {
    return csv?.entries.elementAtOrNull(currentEntryIndex);
  }

  // for columns mapping

  EImportColumn? currentColumn;

  List<TMappedColumn> mappedColumns = [];

  EImportColumn? getColumn(String entryKey) {
    return mappedColumns
        .where((e) => e.entryKey == entryKey)
        .firstOrNull
        ?.column;
  }

  bool isOccupied(String entryKey) {
    final occupied = mappedColumns.take(max(0, mappedColumns.length - 1));
    return occupied.any((e) => e.entryKey == entryKey);
  }

  String get numberOfEntriesDescription {
    final csv = this.csv;
    if (csv == null || csv.entries.isEmpty) return "0 записей";
    final count = csv.entries.length;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(count);
    return switch (count.wordCaseHint) {
      EWordCaseHint.nominative => "$formatted запись",
      EWordCaseHint.genitive => "$formatted записи",
      EWordCaseHint.accusative => "$formatted записей",
    };
  }

  List<ValidationResult> columnValidationResults = [];

  // for accounts mapping

  AccountVO? singleAccount;
  Map<String, AccountVO?> accounts = {};

  String get numberOfAccountsDescription {
    final count = accounts.length;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(count);
    return switch (count.wordCaseHint) {
      EWordCaseHint.nominative => "$formatted счет",
      EWordCaseHint.genitive => "$formatted счета",
      EWordCaseHint.accusative => "$formatted счетов",
    };
  }

  // for transaction type mapping

  String? mappedTransactionTypeExpense;
  String? mappedTransactionTypeIncome;

  final transactionTypeDecisionController =
      TabGroupController(ETypeDecision.isExpense);

  void _transactionTypeDecisionListener() {
    mapTransactionTypes();
  }

  bool get hasMappedTransactionType {
    return mappedColumns.any((e) {
      return e.column == EImportColumn.transactionType && e.entryKey != null;
    });
  }

  TTransactionsByType get transactionsByType {
    final entries = csv?.entries;
    if (entries == null) {
      return (entriesByType: const [], types: const {}) as TTransactionsByType;
    }
    // we know there is only two or less types
    final Set<String> types = {};
    final typeColumn = mappedColumns
        .where((e) => e.column == EImportColumn.transactionType)
        .firstOrNull;
    if (typeColumn == null) {
      return (entriesByType: const [], types: types) as TTransactionsByType;
    }
    for (final element in entries) {
      types.add(element[typeColumn.entryKey]!);
      if (types.length == 2) break;
    }
    if (types.isEmpty) {
      throw ArgumentError.value(
        types,
        "get transactionTypes",
        "Transaction types shouldn't be empty. There must be at least on type",
      );
    }
    final one = entries
        .where((e) => e[typeColumn.entryKey]! == types.elementAt(0))
        .toList(growable: false);
    final two = types.length > 1
        ? entries
            .where((e) => e[typeColumn.entryKey]! == types.elementAt(1))
            .toList(growable: false)
        : const <Map<String, String>>[];
    return (entriesByType: one.length >= two.length ? one : two, types: types);
  }

  void mapTransactionTypes() {
    final transactionsByType = this.transactionsByType;
    final showedType = transactionsByType.entriesByType.first.entries
        .where((e) => getColumn(e.key) == EImportColumn.transactionType)
        .first
        .value;
    String otherType = "__other_transaction_type__";
    for (final type in transactionsByType.types) {
      if (type != showedType) {
        otherType = type;
        break;
      }
    }
    setState(() {
      switch (transactionTypeDecisionController.value) {
        case ETypeDecision.isExpense:
          mappedTransactionTypeExpense = showedType;
          mappedTransactionTypeIncome = otherType;
        case ETypeDecision.isNotExpense:
          mappedTransactionTypeExpense = otherType;
          mappedTransactionTypeIncome = showedType;
      }
    });
  }

  // for categories mapping

  final Map<ETransactionType, List<CategoryModel>> categoryModels = {
    for (final value in ETransactionType.values) value: const [],
  };

  final Map<ETransactionType, List<TMappedCategory>> mappedCategories = {
    for (final value in ETransactionType.values) value: const [],
  };

  String get numberOfCategoriesDescription {
    final count = mappedCategories.entries
        .fold<int>(0, (prev, curr) => prev + curr.value.length);
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(count);
    return switch (count.wordCaseHint) {
      EWordCaseHint.nominative => "$formatted категория",
      EWordCaseHint.genitive => "$formatted категории",
      EWordCaseHint.accusative => "$formatted категорий",
    };
  }

  @override
  void initState() {
    super.initState();
    transactionTypeDecisionController
        .addListener(_transactionTypeDecisionListener);
  }

  @override
  void dispose() {
    subject.close();
    transactionTypeDecisionController
        .removeListener(_transactionTypeDecisionListener);
    transactionTypeDecisionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<ImportViewModel>(
      viewModel: this,
      useCases: [
        () => OnSelectFilePressed(),
        () => OnBackwardPressed(),
        () => OnForwardPressed(),
        () => OnRotateEntryPressed(),
        () => OnColumnSelected(),
        () => OnColumnInfoPressed(),
        () => OnAccountButtonPressed(),
        () => OnAccountLocalButtonPressedDecorator(),
        () => OnAccountFromImportButtonPressedDecorator(),
        () => OnCategoryButtonPressed(),
        () => OnCategoryResetPressed(),
        () => OnDoneMapping(),
      ],
      child: const ImportView(),
    );
  }
}
