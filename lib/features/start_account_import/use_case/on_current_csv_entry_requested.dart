import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start_account_import/page/page.dart";

final class OnCurrentCsvEntryRequested
    extends UseCase<Map<String, String>?, dynamic> {
  @override
  Map<String, String>? call(BuildContext context, [dynamic _]) {
    final viewModel = context.viewModel<StartAccountImportViewModel>();
    return viewModel.csv?.entries.elementAtOrNull(viewModel.currentEntryIndex);
  }
}
