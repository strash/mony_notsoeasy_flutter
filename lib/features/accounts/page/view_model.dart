import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/accounts/page/view.dart";
import "package:mony_app/features/accounts/use_case/use_case.dart";

final class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  ViewModelState<AccountsPage> createState() => AccountsViewModel();
}

final class AccountsViewModel extends ViewModelState<AccountsPage> {
  late final StreamSubscription<Event> _appSub;

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAppStateCnanged().call(context, (event: event, viewModel: this));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<AccountsViewModel>(
      viewModel: this,
      child: const AccountsView(),
    );
  }
}
