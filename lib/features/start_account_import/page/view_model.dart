import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/start_account_import/page/event.dart";
import "package:mony_app/features/start_account_import/page/view.dart";
import "package:mony_app/features/start_account_import/use_case/use_case.dart";
import "package:rxdart/subjects.dart";

final class StartAccountImportViewModelBuilder extends StatefulWidget {
  const StartAccountImportViewModelBuilder({super.key});

  @override
  ViewModelState<StartAccountImportViewModelBuilder> createState() =>
      StartAccountImportViewModel();
}

final class StartAccountImportViewModel
    extends ViewModelState<StartAccountImportViewModelBuilder> {
  final _subject = BehaviorSubject<ImportEvent>.seeded(ImportEventInitial());
  Stream<ImportEvent> get stream => _subject.stream;

  late final onSelectFilePressed =
      OnSelectFilePressedUseCase(subject: _subject);
  late final onBackPressed = OnBackwardPressedUseCase(subject: _subject);
  late final onForwardPressed = OnForwardPressedUseCase(subject: _subject);
  final onRotateEntryPressed = OnRotateEntryPressedUseCase();
  final onColumnSelected = OnColumnSelectedUseCase();

  int _progress = 0;
  // TODO: указать правильное количество шагов
  final _totalProgress = 11;
  int get progress => (_progress * 100 / _totalProgress).ceil();

  void forward() => setState(() => _progress++);
  void backward() => setState(() => _progress--);

  ImportedCsvValueObject? csv;

  MappedCsvColumnsValueObject mappedCsvColumns =
      const MappedCsvColumnsValueObject(
    account: null,
    amount: null,
    expenseType: null,
    date: null,
    category: null,
    tag: null,
    note: null,
  );

  int currentEntryIndex = 0;
  Map<String, String>? currentEntry;

  void rotateEntry() {
    setState(() {
      if (csv == null || csv!.entries.isEmpty) {
        currentEntry = null;
        currentEntryIndex = 0;
        return;
      }
      if (currentEntryIndex < csv!.entries.length - 1) {
        currentEntryIndex++;
      } else {
        currentEntryIndex = 0;
      }
      currentEntry = csv!.entries.elementAt(currentEntryIndex);
    });
  }

  String get numberOfEntries {
    if (csv == null || csv!.entries.isEmpty) return "0 записей";
    final count = csv!.entries.length;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(count);
    return switch (count.wordCaseHint) {
      EWordCaseHint.nominative => "$formatted запись",
      EWordCaseHint.genitive => "$formatted записи",
      EWordCaseHint.accusative => "$formatted записей",
    };
  }

  String currentColumn = "Счет";

  void _eventListener(ImportEvent event) {
    if (event case ImportEventCsvLoaded(:final csv)) {
      if (csv == null) return;
      setState(() {
        this.csv = csv;
        currentEntry = csv.entries.elementAt(currentEntryIndex);
      });
    } else if (event case ImportEventMapAccount()) {
      setState(() => currentColumn = "Счет");
    } else if (event case ImportEventMapAmount()) {
      setState(() => currentColumn = "Сумма транзакции");
    } else if (event case ImportEventMapExpenseType()) {
      setState(() => currentColumn = "Тип транзакции");
    } else if (event case ImportEventMapDate()) {
      setState(() => currentColumn = "Дата транзакции");
    } else if (event case ImportEventMapCategory()) {
      setState(() => currentColumn = "Категория транзакции");
    } else if (event case ImportEventMapTag()) {
      setState(() => currentColumn = "Тег транзакции");
    } else if (event case ImportEventMapNote()) {
      setState(() => currentColumn = "Заметка транзакции");
    }
  }

  String? selectedColumnName(String key) {
    if (mappedCsvColumns.account == key) {
      return "Счет";
    } else if (mappedCsvColumns.amount == key) {
      return "Сумма";
    } else if (mappedCsvColumns.expenseType == key) {
      return "Тип";
    } else if (mappedCsvColumns.date == key) {
      return "Дата";
    } else if (mappedCsvColumns.category == key) {
      return "Категория";
    } else if (mappedCsvColumns.tag == key) {
      return "Тэг";
    } else if (mappedCsvColumns.note == key) {
      return "Заметка";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _subject.listen(_eventListener);
  }

  @override
  void dispose() {
    _subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<StartAccountImportViewModel>(
      viewModel: this,
      child: const StartAccountImportView(),
    );
  }
}
