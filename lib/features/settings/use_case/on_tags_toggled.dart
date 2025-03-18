import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";

final class OnTagsToggled extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final sharedPrefService = context.service<DomainSharedPreferencesService>();
    final appService = context.viewModel<AppEventService>();

    final currValue = await sharedPrefService.isSettingsTagsVisible();
    final value = !currValue;
    await sharedPrefService.setSettingsTagsVisibility(value);

    appService.notify(EventSettingsTagsVisibilityChanged(value));
  }
}
