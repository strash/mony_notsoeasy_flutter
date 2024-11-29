import "package:flutter/material.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/view_model/view_model.dart";

extension BuildContextEx on BuildContext {
  T viewModel<T extends ViewModelState<StatefulWidget>>() {
    return ViewModel.of<T>(this);
  }

  void close() {
    final route = ModalRoute.of<void>(this);
    final navigator = Navigator.of(this);
    if (route != null) {
      if (route.isCurrent) {
        navigator.pop<void>();
      } else {
        navigator.removeRoute(route);
      }
    }
  }

  Future<T?> go<T>(
    Widget page, {
    bool rootNavigator = false,
    bool noTransition = false,
  }) {
    var navigator = Navigator.of(this);
    if (rootNavigator) navigator = appNavigatorKey.currentState!;

    Route<T> route = MaterialPageRoute(builder: (context) => page);
    if (noTransition) {
      route = PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        pageBuilder: (context, _, __) => page,
      );
    }
    return navigator.push<T>(route);
  }
}
