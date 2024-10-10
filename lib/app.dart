import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";

final appNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "app_key");

class MonyApp extends StatelessWidget {
  const MonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: appNavigatorKey,
      title: "MonyApp",
      routerDelegate: NavigatorDelegate(),
      supportedLocales: const [
        Locale("en", "EN"),
        Locale("ru", "RU"),
      ],
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return child ?? const SizedBox();
      },
    );
  }
}
