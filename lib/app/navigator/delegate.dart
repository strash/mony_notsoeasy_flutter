import "package:flutter/material.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/services/database/account.dart";
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

  Future<bool> _hasAccounts() async {
    return (await _accountService.count()) > 0;
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => appNavigatorKey;

  @override
  Future<void> setNewRoutePath(Object? configuration) async {}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event>(
      stream: _eventService.stream.where((event) {
        switch (event) {
          case EventAccountCreated() ||
                EventAccountDeleted() ||
                EventSettingsDataDeletionRequested() ||
                EventDataImported():
            return true;

          case EventAccountUpdated() ||
                EventCategoryCreated() ||
                EventCategoryUpdated() ||
                EventCategoryDeleted() ||
                EventTransactionCreated() ||
                EventTransactionUpdated() ||
                EventTransactionDeleted() ||
                EventTagCreated() ||
                EventTagUpdated() ||
                EventTagDeleted() ||
                EventSettingsThemeModeChanged() ||
                EventSettingsColorsVisibilityChanged() ||
                EventSettingsCentsVisibilityChanged() ||
                EventSettingsTagsVisibilityChanged():
            return false;
        }
      }),
      builder: (context, snapshot) {
        return FutureBuilder<bool>(
          future: _hasAccounts(),
          builder: (context, fSnapshot) {
            Widget child = const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
            if (fSnapshot.hasData) {
              final hasAccounts = fSnapshot.data!;
              child = hasAccounts ? const NavBarPage() : const StartPage();
            }
            return child;
          },
        );
      },
    );
  }
}
