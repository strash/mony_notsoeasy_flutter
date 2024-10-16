import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/start_account_import/page/model.dart";
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
  final _subject = BehaviorSubject<ImportModelEvent>.seeded(
    const ImportModelEvent.initial(),
  );
  Stream<ImportModelEvent> get stream => _subject.stream;

  late final onSelectFilePressed = OnSelectFilePressedUseCase(
    subject: _subject,
    forward: _forward,
  );
  late final onBackPressed = OnBackPressedUseCase(
    subject: _subject,
    backward: _backward,
  );

  int _progress = 0;
  // TODO: указать правильное количество шагов
  final _totalProgress = 10;
  int get progress => (_progress * 100 / _totalProgress).ceil();

  void _forward() {
    setState(() => _progress++);
  }

  void _backward() {
    setState(() => _progress--);
  }

  ImportedCsvValueObject? csv;

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

  void _eventListener(ImportModelEvent event) {
    if (event is ImportModelEventCsvloaded) {
      setState(() => csv = event.csv);
    }
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
