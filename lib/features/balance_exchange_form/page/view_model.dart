import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/utils/input_controller/controller.dart";
import "package:mony_app/components/select/select.dart";
import "package:mony_app/domain/models/models.dart";
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
  bool isCentsVisible = true;
  bool isColorsVisible = true;

  bool isSubmitEnabled = false;

  late final accountController = SelectController<AccountModel?>(null);
  final amountController = InputController(validators: [AmountValidator()]);

  List<AccountModel> accounts = [];
  List<AccountBalanceModel> balances = [];

  AccountModel get activeAccount {
    return widget.account;
  }

  AccountBalanceModel? get selectedBalance {
    AccountBalanceModel? balance;
    for (final element in balances) {
      if (element.id == accountController.value?.id) {
        balance = element;
        break;
      }
    }
    return balance;
  }

  AccountBalanceModel? get activeBalance {
    AccountBalanceModel? balance;
    for (final element in balances) {
      if (element.id == activeAccount.id) {
        balance = element;
        break;
      }
    }
    return balance;
  }

  EBalanceExchangeMenuItem get action {
    return widget.action;
  }

  void _listener() {
    setProtectedState(() {
      final amountTrim = amountController.text.trim();
      final amountIsValid = amountTrim.isNotEmpty && amountController.isValid;

      isSubmitEnabled = accountController.value != null && amountIsValid;
    });
  }

  @override
  void initState() {
    super.initState();
    accountController.addListener(_listener);
    amountController.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      final sharedPrefService = context.read<DomainSharedPreferencesService>();
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
    accountController.removeListener(_listener);
    amountController.removeListener(_listener);
    accountController.dispose();
    amountController.dispose();
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
