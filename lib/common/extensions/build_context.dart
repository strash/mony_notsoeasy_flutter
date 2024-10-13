import "package:flutter/material.dart";
import "package:mony_app/app.dart";

extension BuildContextEx on BuildContext {
  Future<T?> go<T>(
    Widget page, {
    bool rootNavigator = false,
    bool noTransition = false,
  }) {
    var navigator = Navigator.of(this);
    if (rootNavigator) navigator = appNavigatorKey.currentState!;

    return navigator.push<T>(
      noTransition
          ? PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 200),
              reverseTransitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (context, animation, __, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              pageBuilder: (context, _, __) => page,
            )
          : MaterialPageRoute(builder: (context) => page),
    );
  }
}
