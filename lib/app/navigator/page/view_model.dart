import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";
import "package:provider/provider.dart";

class NavigatorViewModelBuilder extends StatefulWidget {
  const NavigatorViewModelBuilder({super.key});

  @override
  ViewModelState<NavigatorViewModelBuilder> createState() =>
      NavigatorViewModel();
}

final class NavigatorViewModel
    extends ViewModelState<NavigatorViewModelBuilder> {
  bool? _hasAccounts;

  late final StreamSubscription<Event> _subscription;

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

  Future<bool> _checkFlow() async {
    final accountService = context.read<AccountService>();
    return (await accountService.getAll()).isNotEmpty;
  }

  Future<void> _onData(Event event) async {
    if (event is EventAccountCreated && event.sender is! NavigatorViewModel) {
      _hasAccounts = await _checkFlow();
      setProtectedState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      _subscription = ViewModel.of<AppEventService>(context).listen(_onData);
      _hasAccounts = await _checkFlow();
      setProtectedState(() {});
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive()),
    );
    final hasAccounts = _hasAccounts;
    if (hasAccounts != null) {
      if (!hasAccounts) {
        child = HeroControllerScope.none(
          child: Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const StartScreenPage(),
              );
            },
          ),
        );
      } else {
        child = const NavBarPage();
      }
    }

    return ViewModel<NavigatorViewModel>(
      viewModel: this,
      child: child,
    );
  }
}
