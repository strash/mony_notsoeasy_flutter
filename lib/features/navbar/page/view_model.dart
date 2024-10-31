import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:rxdart/subjects.dart";

export "../use_case/use_case.dart";
export "./event.dart";

enum NavbarTabItem {
  feed,
  settings,
  ;

  static int get length => NavbarTabItem.values.length;

  static NavbarTabItem get defaultValue => NavbarTabItem.feed;

  static NavbarTabItem from(int index) {
    return NavbarTabItem.values.elementAt(index);
  }
}

class NavbarViewModelBuilder extends StatefulWidget {
  const NavbarViewModelBuilder({super.key});

  @override
  ViewModelState<NavbarViewModelBuilder> createState() => NavbarViewModel();
}

final class NavbarViewModel extends ViewModelState<NavbarViewModelBuilder> {
  final subject = BehaviorSubject<NavbarEvent>.seeded(
    NavbarEventTabChanged(NavbarTabItem.defaultValue),
  );

  NavbarTabItem currentTab = NavbarTabItem.defaultValue;

  final _routes = NavbarTabItem.values.map((e) {
    return switch (e) {
      NavbarTabItem.feed => const FeedPage(),
      NavbarTabItem.settings => const SettingsPage(),
    };
  }).toList(growable: false);

  final _navigatorTabKeys = NavbarTabItem.values.map((e) {
    return GlobalKey<NavigatorState>(debugLabel: "Tab $e");
  }).toList(growable: false);

  GlobalKey<NavigatorState> getNavigatorTabKey(NavbarTabItem tab) {
    return _navigatorTabKeys.elementAt(tab.index);
  }

  // helper for uniform behavior
  void returnToTop(ScrollController scrollController) {
    if (!scrollController.hasClients) return;
    const curve = Curves.easeInOut;
    const duration = Duration(milliseconds: 500);
    scrollController.animateTo(.0, duration: duration, curve: curve);
  }

  Route<dynamic> onGenerateRoute(NavbarTabItem tab, RouteSettings settings) {
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
    return ViewModel<NavbarViewModel>(
      viewModel: this,
      useCases: [
        () => OnAddTransactionPressed(),
        () => OnTabChangeRequested(),
        () => OnPopTabsToRootRequested(),
        () => OnTopOfScreenPressed(),
      ],
      child: const NavbarView(),
    );
  }
}
