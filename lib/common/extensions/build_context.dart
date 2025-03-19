import "package:flutter/material.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/service_locator/service_locator.dart";
import "package:mony_app/app/view_model/view_model.dart";

extension BuildContextEx on BuildContext {
  T viewModel<T extends ViewModelState<StatefulWidget>>() {
    return ViewModel.of<T>(this);
  }

  T service<T>() {
    return ServiceLocator.of<T>(this);
  }

  void close() {
    final route = ModalRoute.of<void>(this);
    if (route == null) return;
    final navigator = Navigator.of(this);
    if (route.isCurrent) {
      navigator.pop<void>();
    } else {
      navigator.removeRoute(route);
    }
  }

  Future<T?> go<T>(
    Widget page, {
    bool rootNavigator = false,
    bool noTransition = false,
  }) {
    final NavigatorState navigator;
    if (rootNavigator) {
      navigator = kAppNavigatorKey.currentState!;
    } else {
      navigator = Navigator.of(this);
    }

    final Route<T> route;
    if (noTransition) {
      route = PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        pageBuilder: (context, _, _) => page,
      );
    } else {
      route = MaterialPageRoute(builder: (context) => page);
    }

    return navigator.push<T>(route);
  }
}
