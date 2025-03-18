import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/settings/page/view_model.dart";

final class OnConfirmAccountToggled extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final sharedPrefService = context.service<DomainSharedPreferencesService>();
    final viewModel = context.viewModel<SettingsViewModel>();

    final currValue = await sharedPrefService.getSettingsConfirmAccount();
    final value = !currValue;

    await sharedPrefService.setSettingsConfirmAccount(value);

    viewModel.setProtectedState(() {
      viewModel.confirmAccount = value;
    });
  }
}
