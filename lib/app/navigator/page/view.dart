import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";

class NavigatorView extends StatelessWidget {
  final int index;
  final List<Page> pages;

  final _heroController = HeroController();

  NavigatorView({
    super.key,
    required this.index,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<NavigatorViewModel>(context);
    final navKey = viewModel.navigatorKeys.elementAt(index);

    return HeroControllerScope(
      controller: _heroController,
      child: Navigator(
        key: navKey,
        pages: pages,
        restorationScopeId: navKey.toString(),
        onGenerateRoute: (settings) {
          return viewModel.routes.elementAt(index);
        },
        onDidRemovePage: (page) {
          pages.remove(page);
        },
      ),
    );
  }
}
