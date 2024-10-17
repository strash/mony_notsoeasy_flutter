import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_account_import/page/page.dart";
import "package:rxdart/subjects.dart";

final class OnBackwardPressedUseCase
    extends BaseValueUseCase<ImportEvent?, Future<void>> {
  final BehaviorSubject<ImportEvent> _subject;

  ImportEvent? _value;

  OnBackwardPressedUseCase({
    required BehaviorSubject<ImportEvent> subject,
  }) : _subject = subject;

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
    // reset column
    viewModel.setProtectedState(() {
      final columns = viewModel.mappedCsvColumns;
      if (value is ImportEventMapNote) {
        viewModel.mappedCsvColumns = columns.copyWith(note: null);
      } else if (value is ImportEventMapTag) {
        viewModel.mappedCsvColumns = columns.copyWith(tag: null);
      } else if (value is ImportEventMapCategory) {
        viewModel.mappedCsvColumns = columns.copyWith(category: null);
      } else if (value is ImportEventMapDate) {
        viewModel.mappedCsvColumns = columns.copyWith(date: null);
      } else if (value is ImportEventMapExpenseType) {
        viewModel.mappedCsvColumns = columns.copyWith(expenseType: null);
      } else if (value is ImportEventMapAmount) {
        viewModel.mappedCsvColumns = columns.copyWith(amount: null);
      } else if (value is ImportEventMapAccount) {
        viewModel.mappedCsvColumns = columns.copyWith(account: null);
      }
    });
    // go back
    switch (value) {
      case ImportEventInitial() ||
            ImportEventLoadingCsv() ||
            ImportEventErrorLoadingCsv():
        return;
      case ImportEventCsvLoaded():
        _subject.add(ImportEventInitial());
      case ImportEventMapAccount():
        _subject.add(ImportEventCsvLoaded(null));
      case ImportEventMapAmount():
        _subject.add(ImportEventMapAccount());
      case ImportEventMapExpenseType():
        _subject.add(ImportEventMapAmount());
      case ImportEventMapDate():
        _subject.add(ImportEventMapExpenseType());
      case ImportEventMapCategory():
        _subject.add(ImportEventMapDate());
      case ImportEventMapTag():
        _subject.add(ImportEventMapCategory());
      case ImportEventMapNote():
        _subject.add(ImportEventMapTag());
    }
    viewModel.backward();
    this.value = null;
  }
}
