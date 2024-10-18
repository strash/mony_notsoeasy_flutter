import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_account_import/page/page.dart";

final class OnCurrentCsvEntryRequestedUseCase
    extends BaseUseCase<Map<String, String>?> {
  @override
  Map<String, String>? action(BuildContext context) {
    final viewModel = ViewModel.of<StartAccountImportViewModel>(context);
    return viewModel.csv?.entries.elementAtOrNull(viewModel.currentEntryIndex);
  }
}
