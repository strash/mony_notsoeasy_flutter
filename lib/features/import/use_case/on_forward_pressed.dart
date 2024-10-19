import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/import.dart";

final class OnForwardPressed extends UseCase<Future<void>, ImportEvent?> {
  @override
  Future<void> call(BuildContext context, [ImportEvent? event]) async {
    if (event == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<ImportViewModel>();
    final subject = viewModel.subject;
    switch (event) {
      case ImportEventCsvLoaded():
        subject.add(ImportEventMappingColumns());
        viewModel.setProtectedState(() {
          viewModel.mappedColumns = List.from(
            viewModel.mappedColumns
              ..add((column: EImportColumn.defaultValue, entryKey: null)),
          );
          viewModel.currentColumn = EImportColumn.defaultValue;
        });
      case ImportEventMappingColumns():
        final nextCol = EImportColumn.from(viewModel.mappedColumns.length);
        if (nextCol == null) {
          subject.add(ImportEventValidatingMappedColumns());
        } else {
          viewModel.setProtectedState(() {
            viewModel.mappedColumns = List.from(
              viewModel.mappedColumns..add((column: nextCol, entryKey: null)),
            );
            viewModel.currentColumn = nextCol;
          });
        }
      default:
        break;
    }
    viewModel.setProtectedState(() {
      viewModel.progress++;
    });
  }
}
