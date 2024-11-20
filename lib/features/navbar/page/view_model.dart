import "package:flutter/material.dart";
import "package:mony_app/app/descriptable/descriptable.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:rxdart/subjects.dart";

export "../use_case/use_case.dart";
export "./event.dart";

enum NavBarTabItem implements IDescriptable {
  feed,
  stats,
  settings,
  ;

  static int get length => NavBarTabItem.values.length;

  static NavBarTabItem get defaultValue => NavBarTabItem.feed;

  static NavBarTabItem from(int index) {
    return NavBarTabItem.values.elementAt(index);
  }

  @override
  String get description {
    return switch (this) {
      NavBarTabItem.feed => "Лента",
      NavBarTabItem.stats => "Статистика",
      NavBarTabItem.settings => "Настройки",
    };
  }
}

class NavBarViewModelBuilder extends StatefulWidget {
  const NavBarViewModelBuilder({super.key});

  @override
  ViewModelState<NavBarViewModelBuilder> createState() => NavBarViewModel();
}

final class NavBarViewModel extends ViewModelState<NavBarViewModelBuilder> {
  final subject = BehaviorSubject<NavBarEvent>.seeded(
    NavBarEventTabChanged(NavBarTabItem.defaultValue),
  );

  NavBarTabItem currentTab = NavBarTabItem.defaultValue;

  final _routes = NavBarTabItem.values.map((e) {
    return switch (e) {
      NavBarTabItem.feed => const FeedPage(),
      NavBarTabItem.stats => const StatsPage(),
      NavBarTabItem.settings => const SettingsPage(),
    };
  }).toList(growable: false);

  final _navigatorTabKeys = NavBarTabItem.values.map((e) {
    return GlobalKey<NavigatorState>(debugLabel: "Tab $e");
  }).toList(growable: false);

  GlobalKey<NavigatorState> getNavigatorTabKey(NavBarTabItem tab) {
    return _navigatorTabKeys.elementAt(tab.index);
  }

  // helper for uniform behavior
  void returnToTop(ScrollController scrollController) {
    if (!scrollController.isReady) return;
    const curve = Curves.easeInOut;
    const duration = Duration(milliseconds: 500);
    scrollController.animateTo(.0, duration: duration, curve: curve);
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
        () => OnAddTransactionPressed(),
        () => OnTabChangeRequested(),
        () => OnPopTabsToRootRequested(),
        () => OnTopOfScreenPressed(),
      ],
      child: const NavBarView(),
    );
  }
}
