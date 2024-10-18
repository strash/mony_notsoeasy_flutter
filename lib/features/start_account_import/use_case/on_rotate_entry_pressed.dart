import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/start_account_import/page/view_model.dart";

final class OnRotateEntryPressedUseCase extends BaseUseCase<void> {
  @override
  void action(BuildContext context) {
    final viewModel = ViewModel.of<StartAccountImportViewModel>(context);
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
