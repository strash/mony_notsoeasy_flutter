import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/navigator/navigator.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/navbar/page/view.dart";

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
  const NavBarViewModelBuilder({
    super.key,
  });

  @override
  ViewModelState<NavBarViewModelBuilder> createState() => NavBarViewModel();
}

final class NavBarViewModel extends ViewModelState<NavBarViewModelBuilder> {
  final _tabController = StreamController<NavBarTabItem>.broadcast();

  late final _navigator = ViewModel.of<NavigatorViewModel>(context);

  NavBarTabItem _tab = NavBarTabItem.defaultValue;

  Stream<NavBarTabItem> get tabStream => _tabController.stream;

  int get tab => _tab.index;

  set tab(int index) {
    final newTab = NavBarTabItem.from(index);
    if (_tab == newTab) {
      _navigator.popTabToRoot(newTab);
    } else {
      _tab = newTab;
      _tabController.add(_tab);
    }
  }

  void setTab(NavBarTabItem newTab) {
    if (_tab == newTab) {
      _navigator.popTabToRoot(newTab);
    } else {
      _tab = newTab;
      _tabController.add(newTab);
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
