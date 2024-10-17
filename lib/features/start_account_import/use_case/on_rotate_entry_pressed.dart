import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/start_account_import/page/view_model.dart";

final class OnRotateEntryPressedUseCase extends BaseUseCase<void> {
  @override
  void action(BuildContext context) {
    final viewModel = ViewModel.of<StartAccountImportViewModel>(context);
    viewModel.rotateEntry();
  }
}
