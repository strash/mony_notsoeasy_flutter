import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:rxdart/subjects.dart";

export "../use_case/use_case.dart";

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
  final subject =
      BehaviorSubject<NavBarTabItem>.seeded(NavBarTabItem.defaultValue);

  NavBarTabItem currentTab = NavBarTabItem.defaultValue;

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

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<NavBarViewModel>(
      viewModel: this,
      useCases: [
        () => OnAddExpensePressed(),
        () => OnTabChangeRequested(),
        () => OnPopTabsToRootRequested(),
      ],
      child: const NavBarView(),
    );
  }
}
