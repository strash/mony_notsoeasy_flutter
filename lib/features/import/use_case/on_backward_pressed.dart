import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/page/page.dart";

final class OnBackwardPressed extends UseCase<Future<void>, ImportEvent?> {
  @override
  Future<void> call(BuildContext context, [ImportEvent? event]) async {
    if (event == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<ImportViewModel>();
    final subject = viewModel.subject;
    // go back
    switch (event) {
      case ImportEventInitial() ||
            ImportEventLoadingCsv() ||
            ImportEventErrorLoadingCsv():
        return;
      case ImportEventCsvLoaded():
        subject.add(ImportEventInitial());
      case ImportEventMappingColumns():
        viewModel.setProtectedState(() {
          if (viewModel.mappedColumns.isNotEmpty) {
            viewModel.mappedColumns =
                List.from(viewModel.mappedColumns..removeLast());
          }
          viewModel.currentColumn = viewModel.mappedColumns.lastOrNull?.column;
        });
        if (viewModel.mappedColumns.isEmpty) {
          subject.add(ImportEventCsvLoaded());
        }
      case ImportEventValidatingMappedColumns() ||
            ImportEventErrorMappingColumns() ||
            ImportEventMappingColumnsValidated():
        subject.add(ImportEventMappingColumns());
    }
    viewModel.setProtectedState(() {
      viewModel.progress--;
    });
  }
}
