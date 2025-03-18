import "package:flutter/material.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";

final class OnThemeModePressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final sharedPrefService = context.service<DomainSharedPreferencesService>();
    final appService = context.viewModel<AppEventService>();

    final currValue = await sharedPrefService.getSettingsThemeMode();
    final value = ThemeMode.values.elementAt(
      (currValue.index + 1).wrapi(0, ThemeMode.values.length),
    );

    sharedPrefService.setSettingsThemeMode(value);

    appService.notify(EventSettingsThemeModeChanged(value));
  }
}
