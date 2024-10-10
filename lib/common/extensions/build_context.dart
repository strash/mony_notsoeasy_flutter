import "package:flutter/material.dart";
import "package:mony_app/app.dart";

extension BuildContextEx on BuildContext {
  Future<T?> go<T>(Widget page, {bool rootNavigator = false}) {
    var navigator = Navigator.of(this);

    if (rootNavigator) {
      navigator = appNavigatorKey.currentState!;
    }

    return navigator.push<T>(MaterialPageRoute(builder: (context) => page));
  }
}
