import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/domain.dart";
import "package:provider/provider.dart";

final appNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "app_key");

class MonyApp extends StatelessWidget {
  const MonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final eventService = ViewModel.of<AppEventService>(context);
    final accountService = context.read<AccountService>();

    return ScreenUtilInit(
      designSize: const Size(393.0, 852.0),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: "Mony App",
          routerDelegate: NavigatorDelegate(
            eventService: eventService,
            accountService: accountService,
          ),
          // TODO: добавить смену темы через AppEventService
          theme: lightTheme,
          darkTheme: darkTheme,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale("en", "EN"),
            Locale("ru", "RU"),
          ],
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
      },
    );
  }
}
