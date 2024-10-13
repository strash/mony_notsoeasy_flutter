import "package:flutter/material.dart";

class NavigatorWrapper extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Route<dynamic>? Function(RouteSettings) onGenerateRoute;

  const NavigatorWrapper({
    super.key,
    required this.navigatorKey,
    required this.onGenerateRoute,
  });

  @override
  Widget build(BuildContext context) {
    return HeroControllerScope(
      controller: MaterialApp.createMaterialHeroController(),
      child: Navigator(
        key: navigatorKey,
        restorationScopeId: navigatorKey.toString(),
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
