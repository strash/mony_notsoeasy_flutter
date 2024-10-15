import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/navbar/use_case/use_case.dart";
import "package:rxdart/subjects.dart";

enum NavBarTabItem {
  feed,
  settings,
  ;

  static int get length => NavBarTabItem.values.length;

  static NavBarTabItem get defaultValue => NavBarTabItem.feed;

  static NavBarTabItem from(int index) {
    return NavBarTabItem.values.elementAt(index);
  }
}

class NavBarViewModelBuilder extends StatefulWidget {
  const NavBarViewModelBuilder({super.key});

  @override
  ViewModelState<NavBarViewModelBuilder> createState() => NavBarViewModel();
}

final class NavBarViewModel extends ViewModelState<NavBarViewModelBuilder> {
  final _tabController = BehaviorSubject<NavBarTabItem>();
  final onAddExpensePressed = OnAddExpensePressedUseCase();

  final _routes = NavBarTabItem.values.map((e) {
    return switch (e) {
      NavBarTabItem.feed => const FeedPage(),
      NavBarTabItem.settings => const SettingsPage(),
    };
  }).toList(growable: false);

  final _navigatorTabKeys = NavBarTabItem.values.map((e) {
    return GlobalKey<NavigatorState>(debugLabel: "Tab $e");
  }).toList(growable: false);

  GlobalKey<NavigatorState> getNavigatorTabKey(NavBarTabItem tab) {
    return _navigatorTabKeys.elementAt(tab.index);
  }

  Route<dynamic> onGenerateRoute(NavBarTabItem tab, RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => _routes.elementAt(tab.index),
    );
  }

  Stream<NavBarTabItem> get tabStream => _tabController.stream;

  NavBarTabItem _tab = NavBarTabItem.defaultValue;

  int get tab => _tab.index;

  set tab(int index) {
    final newTab = NavBarTabItem.from(index);
    if (_tab == newTab) {
      popTabToRoot(newTab);
    } else {
      _tab = newTab;
      _tabController.add(_tab);
    }
  }

  void setTab(NavBarTabItem newTab) {
    tab = newTab.index;
  }

  void popTabToRoot(NavBarTabItem tab) {
    final key = _navigatorTabKeys.elementAt(tab.index);
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
  void dispose() {
    _tabController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<NavBarViewModel>(
      viewModel: this,
      child: const NavBarView(),
    );
  }
}
