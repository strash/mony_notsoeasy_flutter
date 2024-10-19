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
          viewModel.progress++;
        });
      case ImportEventMappingColumns():
        final col = EImportColumn.from(viewModel.mappedColumns.length);
        // TODO: переходить на следующий шаг
        if (col == null) {
          return;
        }
        viewModel.setProtectedState(() {
          viewModel.mappedColumns = List.from(
            viewModel.mappedColumns..add((column: col, entryKey: null)),
          );
          viewModel.currentColumn = col;
          viewModel.progress++;
        });
      default:
        return;
    }
  }
}
