import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/components/select/select.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/balance_exchange_form/page/view.dart";
import "package:mony_app/features/balance_exchange_form/use_case/use_case.dart";
import "package:provider/provider.dart";

enum EBalanceExchangeMenuItem { receive, send }

final class BalanceExchangeFormPage extends StatefulWidget {
  final double keyboardHeight;
  final AccountModel account;
  final EBalanceExchangeMenuItem action;

  const BalanceExchangeFormPage({
    super.key,
    required this.keyboardHeight,
    required this.account,
    required this.action,
  });

  @override
  ViewModelState<BalanceExchangeFormPage> createState() =>
      BalanceExchangeFormViewModel();
}

final class BalanceExchangeFormViewModel
    extends ViewModelState<BalanceExchangeFormPage> {
  bool isColorsVisible = true;

  bool isSubmitEnabled = false;

  late final accountController = SelectController<AccountModel?>(null);
  List<AccountModel> accounts = [];

  AccountModel get account {
    return widget.account;
  }

  EBalanceExchangeMenuItem get action {
    return widget.action;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      final sharedPrefService = context.read<DomainSharedPreferencesService>();
      final colors = await sharedPrefService.isSettingsColorsVisible();
      setProtectedState(() {
        isColorsVisible = colors;
      });

      if (!mounted) return;
      OnInit().call(context, this);
    });
  }

  @override
  void dispose() {
    accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      viewModel: this,
      child: BalanceExchangeFormView(keyboardHeight: widget.keyboardHeight),
    );
  }
}
