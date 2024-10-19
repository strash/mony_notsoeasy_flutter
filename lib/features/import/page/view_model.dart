import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/features/import/page/view.dart";
import "package:mony_app/features/import/use_case/use_case.dart";
import "package:rxdart/subjects.dart";

final class ImportViewModelBuilder extends StatefulWidget {
  const ImportViewModelBuilder({super.key});

  @override
  ViewModelState<ImportViewModelBuilder> createState() => ImportViewModel();
}

typedef TMappedColumn = ({EImportColumn column, String? entryKey});

final class ImportViewModel extends ViewModelState<ImportViewModelBuilder> {
  final subject = BehaviorSubject<ImportEvent>.seeded(ImportEventInitial());

  int progress = 0;

  int get progressPercentage => (progress * 100 / _totalProgress).round();

  // TODO: указать правильное количество шагов
  final _totalProgress = 11;

  ImportedCsvValueObject? csv;

  Map<String, String>? get currentEntry {
    return csv?.entries.elementAtOrNull(currentEntryIndex);
  }

  int currentEntryIndex = 0;

  EImportColumn? currentColumn;
  List<TMappedColumn> mappedColumns = [];

  String? getShortTitle(String entryKey) {
    return mappedColumns
        .where((e) => e.entryKey == entryKey)
        .firstOrNull
        ?.column
        .shortTitle;
  }

  bool isOccupied(String entryKey) {
    final occupied = mappedColumns.take(mappedColumns.length - 1);
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

  @override
  void dispose() {
    subject.close();
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
      ],
      child: const ImportView(),
    );
  }
}
