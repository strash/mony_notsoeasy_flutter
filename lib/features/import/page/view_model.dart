import "dart:math";

import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/features/import/page/view.dart";
import "package:mony_app/features/import/use_case/use_case.dart";
import "package:rxdart/subjects.dart";

export "../validator/validator.dart";
export "./model/model.dart";

// TODO: Импорт со счетами:
// - теги и категории уже мержатся
// - мержить транзакции
// - мержить счета?
// - ?

typedef TPressedCategoryValue =
    ({ETransactionType transactionType, ImportModelCategoryVariant category});

final class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  ViewModelState<ImportPage> createState() => ImportViewModel();
}

final class ImportViewModel extends ViewModelState<ImportPage> {
  final subject = BehaviorSubject<ImportEvent>.seeded(ImportEventInitial());

  List<ImportModel> steps = const [];
  late ImportModel currentStep = ImportModelCsv(csv: null);

  int get progressPercentage {
    return (steps.length * 100 / max(1, _totalProgress + additionalSteps))
        .round();
  }

  final _totalProgress = 11;
  int additionalSteps = 0;

  ImportedCsvVO? get csv {
    final m = steps.whereType<ImportModelCsv>().firstOrNull;
    if (m == null || m.csv == null || m.csv!.entries.isEmpty) return null;
    return m.csv;
  }

  int currentEntryIndex = 0;

  ImportModelColumn? get currentColumn {
    final col = currentStep;
    if (col is! ImportModelColumn) return null;
    return col;
  }

  List<ImportModelColumn> get mappedColumns {
    return steps.whereType<ImportModelColumn>().toList(growable: false);
  }

  final transactionTypeController = TabGroupController(
    ETransactionType.expense,
  );

  void _transactionTypeListener() {
    final typeModel = currentStep;
    if (typeModel is! ImportModelTransactionType) {
      throw ArgumentError.value(typeModel);
    }
    final value = transactionTypeController.value;
    typeModel.remap(typeModel.largest.typeValue, value);
  }

  Map<ETransactionType, List<CategoryModel>> categoryModels = {
    for (final value in ETransactionType.values) value: const [],
  };

  @override
  void initState() {
    super.initState();
    transactionTypeController.addListener(_transactionTypeListener);
  }

  @override
  void dispose() {
    void forEachAction(ImportModel e) => e.dispose();
    steps.forEach(forEachAction);
    if (steps.isNotEmpty && currentStep != steps.last) currentStep.dispose();
    subject.close();
    transactionTypeController.removeListener(_transactionTypeListener);
    transactionTypeController.dispose();
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
        () => OnCategoryButtonPressed(),
        () => OnCategoryResetPressed(),
        () => OnDoneMapping(),
      ],
      child: const ImportView(),
    );
  }
}
