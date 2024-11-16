import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/page/page.dart";

final class OnColumnSelected extends UseCase<void, String> {
  @override
  void call(BuildContext context, [String? entryKey]) {
    if (entryKey == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<ImportViewModel>();
    final column = viewModel.currentColumn;
    if (column == null) throw ArgumentError.notNull();

    final newValue = column.value == entryKey ? null : entryKey;
    if (newValue == null || viewModel.columns.any((e) => e.value == newValue)) {
      return;
    }

    viewModel.setProtectedState(() {
      viewModel.currentStep = column.copyWith(value: newValue);
      column.dispose();
    });
  }
}
