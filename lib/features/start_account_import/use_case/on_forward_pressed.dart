import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start_account_import/page/event.dart";
import "package:mony_app/features/start_account_import/page/view_model.dart";

final class OnForwardPressedUseCase
    extends BaseValueUseCase<ImportEvent?, Future<void>> {
  @override
  Future<void> action(BuildContext context, ImportEvent? value) async {
    if (value == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<StartAccountImportViewModel>();
    final subject = viewModel.subject;
    switch (value) {
      case ImportEventInitial() ||
            ImportEventLoadingCsv() ||
            ImportEventErrorLoadingCsv():
        return;
      case ImportEventCsvLoaded():
        subject.add(ImportEventMapAccount());
      case ImportEventMapAccount():
        subject.add(ImportEventMapAmount());
      case ImportEventMapAmount():
        subject.add(ImportEventMapExpenseType());
      case ImportEventMapExpenseType():
        subject.add(ImportEventMapDate());
      case ImportEventMapDate():
        subject.add(ImportEventMapCategory());
      case ImportEventMapCategory():
        subject.add(ImportEventMapTag());
      case ImportEventMapTag():
        subject.add(ImportEventMapNote());
      case ImportEventMapNote():
        return;
    }
    viewModel.setProtectedState(() {
      viewModel.progress++;
    });
  }
}
