import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/page/page.dart";

final class OnColumnSelected extends UseCase<void, String> {
  @override
  void call(BuildContext context, [String? entryKey]) {
    if (entryKey == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<ImportViewModel>();
    final currentMappedColumn = viewModel.mappedColumns.lastOrNull;
    if (currentMappedColumn == null) return;

    final newValue = currentMappedColumn.entryKey == entryKey ? null : entryKey;

    viewModel.setProtectedState(() {
      final mappedColumnIndex =
          viewModel.mappedColumns.indexWhere((e) => e.entryKey == entryKey);
      final isOccupied = mappedColumnIndex != -1 &&
          viewModel.mappedColumns.elementAt(mappedColumnIndex).column !=
              currentMappedColumn.column;
      if (isOccupied) return;
      viewModel.mappedColumns = List.from(
        viewModel.mappedColumns
          ..removeLast()
          ..add((column: currentMappedColumn.column, entryKey: newValue)),
      );
    });
  }
}
