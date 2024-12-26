import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account/page/view.dart";
import "package:mony_app/features/account/use_case/use_case.dart";

final class AccountPage extends StatefulWidget {
  final AccountModel account;

  const AccountPage({
    super.key,
    required this.account,
  });

  @override
  ViewModelState<AccountPage> createState() => AccountViewModel();
}

final class AccountViewModel extends ViewModelState<AccountPage> {
  late final StreamSubscription<Event> _appSub;

  late AccountModel account = widget.account;

  AccountBalanceModel? balance;

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAppStateChanged().call(context, (event: event, viewModel: this));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);
      OnInit().call(context, this);
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<AccountViewModel>(
      viewModel: this,
      useCases: [
        () => OnEditPressed(),
        () => OnDeletePressed(),
      ],
      child: const AccountView(),
    );
  }
}
