import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/i18n/strings.g.dart";
import "package:rxdart/transformers.dart";

final appNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "app_key");

class MonyApp extends StatefulWidget {
  const MonyApp({super.key});

  @override
  State<MonyApp> createState() => _MonyAppState();
}

class _MonyAppState extends State<MonyApp> {
  late final StreamSubscription<Event> _appSub;

  ThemeMode mode = ThemeMode.system;

  void _onThemeModeChanged(EventSettingsThemeModeChanged event) {
    if (!mounted) return;
    setState(() => mode = event.value);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      _appSub = context
          .viewModel<AppEventService>()
          .stream
          .whereType<EventSettingsThemeModeChanged>()
          .listen(_onThemeModeChanged);
      final sharedPrefService =
          context.service<DomainSharedPreferencesService>();
      final m = await sharedPrefService.getSettingsThemeMode();
      if (!mounted) return;
      setState(() => mode = m);
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventService = context.viewModel<AppEventService>();
    final accountService = context.service<DomainAccountService>();

    return MaterialApp.router(
      title: "Mony App",
      routerDelegate: NavigatorDelegate(
        eventService: eventService,
        accountService: accountService,
      ),
      themeMode: mode,
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return NavigatorWrapper(
          navigatorKey: appNavigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => child ?? const SizedBox(),
            );
          },
        );
      },
    );
  }
}
