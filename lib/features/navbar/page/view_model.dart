import "package:flutter/material.dart";
import "package:mony_app/app/descriptable/descriptable.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/navbar/use_case/use_case.dart";
import "package:rxdart/subjects.dart";

export "./event.dart";

enum ENavBarTabItem implements IDescriptable {
  feed,
  stats,
  settings,
  ;

  static int get length => ENavBarTabItem.values.length;

  static ENavBarTabItem get defaultValue => ENavBarTabItem.feed;

  static ENavBarTabItem from(int index) {
    return ENavBarTabItem.values.elementAt(index);
  }

  @override
  String get description {
    return switch (this) {
      ENavBarTabItem.feed => "Лента",
      ENavBarTabItem.stats => "Статистика",
      ENavBarTabItem.settings => "Настройки",
    };
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key});

  @override
  ViewModelState<NavBarPage> createState() => NavBarViewModel();
}

final class NavBarViewModel extends ViewModelState<NavBarPage> {
  final subject = BehaviorSubject<NavBarEvent>.seeded(
    NavBarEventTabChanged(ENavBarTabItem.defaultValue),
  );

  ENavBarTabItem currentTab = ENavBarTabItem.defaultValue;

  final _routes = ENavBarTabItem.values.map((e) {
    return switch (e) {
      ENavBarTabItem.feed => const FeedPage(),
      ENavBarTabItem.stats => const StatsPage(),
      ENavBarTabItem.settings => const SettingsPage(),
    };
  }).toList(growable: false);

  final _navigatorTabKeys = ENavBarTabItem.values.map((e) {
    return GlobalKey<NavigatorState>(debugLabel: "Tab $e");
  }).toList(growable: false);

  GlobalKey<NavigatorState> getNavigatorTabKey(ENavBarTabItem tab) {
    return _navigatorTabKeys.elementAt(tab.index);
  }

  // helper for uniform behavior
  void returnToTop(ScrollController scrollController) {
    if (!scrollController.isReady) return;
    const curve = Curves.easeInOut;
    const duration = Duration(milliseconds: 500);
    scrollController.animateTo(.0, duration: duration, curve: curve);
  }

  Route<dynamic> onGenerateRoute(ENavBarTabItem tab, RouteSettings settings) {
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
