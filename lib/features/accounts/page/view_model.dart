import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/common/utils/feed_scroll_controller/feed_scroll_controller.dart";
import "package:mony_app/components/account_with_context_menu/use_case/on_context_menu_selected.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/accounts/page/view.dart";
import "package:mony_app/features/accounts/use_case/use_case.dart";

final class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  ViewModelState<AccountsPage> createState() => AccountsViewModel();
}

final class AccountsViewModel extends ViewModelState<AccountsPage> {
  late final StreamSubscription<Event> _appSub;
  late final StreamSubscription<FeedScrollControllerEvent> _scrollSub;

  List<AccountModel> accounts = const [];
  List<AccountBalanceModel> balances = const [];
  int scrollPage = 0;
  bool canLoadMore = true;

  bool isCentsVisible = true;
  bool isColorsVisible = true;

  final _scrollController = FeedScrollController();
  ScrollController get controller => _scrollController.controller;

  void _onFeedEvent(FeedScrollControllerEvent event) {
    if (!mounted) return;
    OnDataFetchRequested().call(context, this);
  }

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAppStateChanged().call(context, (event: event, viewModel: this));
  }

  @override
  void initState() {
    super.initState();
    _scrollSub = _scrollController.addListener(_onFeedEvent);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);

      final sharedPrefService =
          context.service<DomainSharedPreferencesService>();
      final cents = await sharedPrefService.isSettingsCentsVisible();
      final colors = await sharedPrefService.isSettingsColorsVisible();
      setProtectedState(() {
        isCentsVisible = cents;
        isColorsVisible = colors;
      });

      if (!mounted) return;
      OnDataFetchRequested().call(context, this);
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    _scrollSub.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<AccountsViewModel>(
      viewModel: this,
      useCases: [
        () => OnAddAccountPressed(),
        () => OnAccountPressed(),
        () => OnAccountWithContextMenuSelected(),
      ],
      child: const AccountsView(),
    );
  }
}
