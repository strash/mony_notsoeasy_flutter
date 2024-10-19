import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/page/view_model.dart";

final class OnRotateEntryPressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [dynamic _]) {
    final viewModel = context.viewModel<ImportViewModel>();
    viewModel.setProtectedState(() {
      if (viewModel.csv == null || viewModel.csv!.entries.isEmpty) {
        viewModel.currentEntryIndex = 0;
        return;
      }
      if (viewModel.currentEntryIndex < viewModel.csv!.entries.length - 1) {
        viewModel.currentEntryIndex++;
      } else {
        viewModel.currentEntryIndex = 0;
      }
    });
  }
}
