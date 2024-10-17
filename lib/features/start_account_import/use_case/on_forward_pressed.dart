import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_account_import/page/event.dart";
import "package:mony_app/features/start_account_import/page/view_model.dart";
import "package:rxdart/subjects.dart";

final class OnForwardPressedUseCase
    extends BaseValueUseCase<ImportEvent?, Future<void>> {
  final BehaviorSubject<ImportEvent> _subject;

  ImportEvent? _value;

  OnForwardPressedUseCase({required BehaviorSubject<ImportEvent> subject})
      : _subject = subject;

  @override
  set value(ImportEvent? newValue) {
    _value = newValue;
  }

  @override
  ImportEvent? get value => _value;

  @override
  Future<void> action(BuildContext context) async {
    final value = this.value;
    if (value == null) throw ArgumentError.notNull();
    final viewModel = ViewModel.of<StartAccountImportViewModel>(context);
    switch (value) {
      case ImportEventInitial() ||
            ImportEventLoadingCsv() ||
            ImportEventErrorLoadingCsv():
        return;
      case ImportEventCsvLoaded():
        _subject.add(ImportEventMapAccount());
      case ImportEventMapAccount():
        _subject.add(ImportEventMapAmount());
      case ImportEventMapAmount():
        _subject.add(ImportEventMapExpenseType());
      case ImportEventMapExpenseType():
        _subject.add(ImportEventMapDate());
      case ImportEventMapDate():
        _subject.add(ImportEventMapCategory());
      case ImportEventMapCategory():
        _subject.add(ImportEventMapTag());
      case ImportEventMapTag():
        _subject.add(ImportEventMapNote());
      case ImportEventMapNote():
        return;
    }
    viewModel.forward();
    this.value = null;
  }
}
