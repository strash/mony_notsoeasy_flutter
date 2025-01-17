import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/settings/page/view.dart";
import "package:mony_app/features/settings/use_case/use_case.dart";
import "package:provider/provider.dart";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  ViewModelState<SettingsPage> createState() => SettingsViewModel();
}

final class SettingsViewModel extends ViewModelState<SettingsPage> {
  late final StreamSubscription<Event> _appSub;

  ThemeMode themeMode = ThemeMode.system;
  bool isColorsVisible = true;
  bool isCentsVisible = true;
  bool isTagsVisible = true;

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAppStateChanged().call(context, (event: event, viewModel: this));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timastamp) async {
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);

      final sharedPrefService = context.read<DomainSharedPreferencesService>();
      final mode = await sharedPrefService.getSettingsThemeMode();
      final colors = await sharedPrefService.isSettingsColorsVisible();
      final cents = await sharedPrefService.isSettingsCentsVisible();
      final tags = await sharedPrefService.isSettingsTagsVisible();
      setProtectedState(() {
        themeMode = mode;
        isColorsVisible = colors;
        isCentsVisible = cents;
        isTagsVisible = tags;
      });
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<SettingsViewModel>(
      viewModel: this,
      useCases: [
        () => OnThemeModePressed(),
        () => OnColorsToggled(),
        () => OnCentsToggled(),
        () => OnTagsToggled(),
      ],
      child: const SettingsView(),
    );
  }
}
