import "package:flutter/material.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/services/account.dart";
import "package:mony_app/features/features.dart";

final class NavigatorDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  final AppEventService _eventService;
  final DomainAccountService _accountService;

  NavigatorDelegate({
    required AppEventService eventService,
    required DomainAccountService accountService,
  })  : _accountService = accountService,
        _eventService = eventService;

  Future<bool> _checkAccounts() async {
    return (await _accountService.getAll()).isNotEmpty;
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => appNavigatorKey;

  @override
  Future<void> setNewRoutePath(Object? configuration) async {}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event>(
      // TODO: слушать еще удаление аккаунта
      stream: _eventService.stream.where((event) {
        return event is EventAccountCreated;
      }),
      builder: (context, snapshot) {
        return FutureBuilder<bool>(
          future: _checkAccounts(),
          builder: (context, fSnapshot) {
            Widget child = const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
            if (fSnapshot.hasData) {
              final hasAccounts = fSnapshot.data!;
              child = hasAccounts ? const NavbarPage() : const StartPage();
            }
            return child;
          },
        );
      },
    );
  }
}
