import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:provider/provider.dart";

final class OnCentsToggled extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final sharedPrefService = context.read<DomainSharedPreferencesService>();
    final appService = context.viewModel<AppEventService>();

    final currValue = await sharedPrefService.isSettingsCentsVisible();
    final value = !currValue;

    await sharedPrefService.setSettingsCents(value);

    appService.notify(EventSettingsCentsVisibilityChanged(value));
  }
}
