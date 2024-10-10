import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/features.dart";

class NavigatorViewModelBuilder extends StatefulWidget {
  const NavigatorViewModelBuilder({super.key});

  @override
  ViewModelState<NavigatorViewModelBuilder> createState() =>
      NavigatorViewModel();
}

final class NavigatorViewModel
    extends ViewModelState<NavigatorViewModelBuilder> {
  late final routes = List.generate(NavBarTabItem.length, (index) {
    return MaterialPageRoute(
      builder: (context) {
        return switch (NavBarTabItem.from(index)) {
          NavBarTabItem.feed => const FeedPage(),
          NavBarTabItem.settings => const SettingsPage(),
        };
      },
    );
  });

  late final navigatorKeys = List.generate(NavBarTabItem.length, (index) {
    return GlobalKey<NavigatorState>(
      debugLabel: "Tab ${NavBarTabItem.from(index)}",
    );
  });

  void popTabToRoot(NavBarTabItem tab) {
    final key = navigatorKeys.elementAt(tab.index);
    final navigatorState = key.currentState;
    if (navigatorState == null) return;
    switch (navigatorState.canPop()) {
      // закрываем все экраны в текущем табе до первого
      case true:
        navigatorState.popUntil((route) => route.isFirst);
      // если нечего закрывать, то скролим наверх
      case false:
      // TODO: тут поидеи можно сообщать экрану, что он может скролить до верха
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<NavigatorViewModel>(
      viewModel: this,
      child: const NavBarPage(),
    );
  }
}
