import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start_account_import/page/page.dart";

final class OnBackwardPressedUseCase
    extends BaseValueUseCase<ImportEvent?, Future<void>> {
  @override
  Future<void> action(BuildContext context, ImportEvent? value) async {
    if (value == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<StartAccountImportViewModel>();
    final subject = viewModel.subject;
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
        subject.add(ImportEventInitial());
      case ImportEventMapAccount():
        subject.add(ImportEventCsvLoaded());
      case ImportEventMapAmount():
        subject.add(ImportEventMapAccount());
      case ImportEventMapExpenseType():
        subject.add(ImportEventMapAmount());
      case ImportEventMapDate():
        subject.add(ImportEventMapExpenseType());
      case ImportEventMapCategory():
        subject.add(ImportEventMapDate());
      case ImportEventMapTag():
        subject.add(ImportEventMapCategory());
      case ImportEventMapNote():
        subject.add(ImportEventMapTag());
    }
    viewModel.setProtectedState(() {
      viewModel.progress--;
    });
  }
}
