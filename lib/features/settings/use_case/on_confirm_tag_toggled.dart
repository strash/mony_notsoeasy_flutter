import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/settings/page/view_model.dart";
import "package:provider/provider.dart";

final class OnConfirmTagToggled extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final sharedPrefService = context.read<DomainSharedPreferencesService>();
    final viewModel = context.viewModel<SettingsViewModel>();

    final currValue = await sharedPrefService.getSettingsConfirmTag();
    final value = !currValue;

    await sharedPrefService.setSettingsConfirmTag(value);

    viewModel.setProtectedState(() {
      viewModel.confirmTag = value;
    });
  }
}
