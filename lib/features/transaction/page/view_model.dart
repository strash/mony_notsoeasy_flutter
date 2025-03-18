import "dart:async";

import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/account_balance.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/transaction/page/view.dart";
import "package:mony_app/features/transaction/use_case/use_case.dart";

final class TransactionPage extends StatefulWidget {
  final TransactionModel transaction;

  const TransactionPage({super.key, required this.transaction});

  @override
  ViewModelState<TransactionPage> createState() => TransactionViewModel();
}

final class TransactionViewModel extends ViewModelState<TransactionPage> {
  late final StreamSubscription<Event> _appSub;

  late TransactionModel transaction = widget.transaction;
  AccountBalanceModel? balance;

  bool isCentsVisible = true;
  bool isColorsVisible = true;

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAppStateChanged().call(context, (event: event, viewModel: this));
  }

  @override
  void initState() {
    super.initState();
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
    return ViewModel<TransactionViewModel>(
      viewModel: this,
      useCases: [
        () => OnTransactionWithContextMenuSelected(),
        () => OnAccountPressed(),
        () => OnCategoryPressed(),
        () => OnTagPressed(),
      ],
      child: const TransactionView(),
    );
  }
}
