import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/features.dart";

final class NavigatorDelegate extends RouterDelegate<Object> {
  final AppEventService _eventService;
  final Future<bool> Function() _checkAccounts;

  NavigatorDelegate({
    required AppEventService eventService,
    required Future<bool> Function() checkAccounts,
  })  : _checkAccounts = checkAccounts,
        _eventService = eventService;

  @override
  Future<bool> popRoute() async {
    return false;
  }

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  Future<void> setNewRoutePath(Object? configuration) async {}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EventAccountCreated>(
      stream: _eventService.stream
          .where((e) => e is EventAccountCreated)
          .distinct()
          .cast<EventAccountCreated>(),
      builder: (context, snapshot) {
        return FutureBuilder<bool?>(
          future: _checkAccounts(),
          builder: (context, fSnapshot) {
            Widget child = const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
            final hasAccounts = fSnapshot.data;
            if (hasAccounts != null) {
              if (hasAccounts) {
                child = const NavBarPage();
              } else {
                child = const StartPage();
              }
            }
            return child;
          },
        );
      },
    );
  }
}
