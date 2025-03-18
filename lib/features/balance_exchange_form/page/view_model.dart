import "package:flutter/material.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/common/utils/input_controller/controller.dart";
import "package:mony_app/components/select/select.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/balance_exchange_form/page/view.dart";
import "package:mony_app/features/balance_exchange_form/use_case/use_case.dart";
import "package:mony_app/i18n/strings.g.dart";

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

  bool isConvertEnabled = false;
  bool isSubmitEnabled = false;

  final accountController = SelectController<AccountModel?>(null);
  final amountController = InputController();
  final coefficientController = InputController();

  List<AccountModel> accounts = [];
  List<AccountBalanceModel> balances = [];

  Color color(AccountModel? account) {
    final theme = Theme.of(context);
    if (account == null) return theme.colorScheme.onSurface;
    final ex = theme.extension<ColorExtension>();
    return ex?.from(account.colorName).color ?? theme.colorScheme.onSurface;
  }

  EBalanceExchangeMenuItem get action {
    return widget.action;
  }

  AccountModel get activeAccount {
    return widget.account;
  }

  bool get isSameCurrency {
    return activeBalance?.currency == selectedBalance?.currency;
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

  AccountModel? get leftAccount {
    return switch (action) {
      EBalanceExchangeMenuItem.receive => accountController.value,
      EBalanceExchangeMenuItem.send => activeAccount,
    };
  }

  AccountModel? get rightAccount {
    return switch (action) {
      EBalanceExchangeMenuItem.receive => activeAccount,
      EBalanceExchangeMenuItem.send => accountController.value,
    };
  }

  AccountBalanceModel? get leftBalance {
    return switch (action) {
      EBalanceExchangeMenuItem.receive => selectedBalance,
      EBalanceExchangeMenuItem.send => activeBalance,
    };
  }

  AccountBalanceModel? get rightBalance {
    return switch (action) {
      EBalanceExchangeMenuItem.receive => activeBalance,
      EBalanceExchangeMenuItem.send => selectedBalance,
    };
  }

  void _listener() {
    setProtectedState(() {
      final amountTrim = amountController.text.trim();
      final amount = (double.tryParse(amountTrim) ?? .0).abs();
      final amountIsValid =
          amountTrim.isNotEmpty && amountController.isValid && amount > .0;

      final isSameCurrency = this.isSameCurrency;
      if (isSameCurrency) {
        isConvertEnabled = false;
        isSubmitEnabled = accountController.value != null && amountIsValid;
      } else {
        final coefficientTrim = coefficientController.text.trim();
        final coefficient = (double.tryParse(coefficientTrim) ?? .0).abs();
        final coefficientIsValid =
            coefficientTrim.isNotEmpty &&
            coefficientController.isValid &&
            coefficient > .0;

        isConvertEnabled = amountIsValid;
        isSubmitEnabled =
            accountController.value != null &&
            amountIsValid &&
            coefficientIsValid;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    accountController.addListener(_listener);
    amountController.addListener(_listener);
    coefficientController.addListener(_listener);

    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      final validator = AmountValidator(translations: context.t);
      amountController.addValidator(validator);
      coefficientController.addValidator(validator);
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
    accountController.removeListener(_listener);
    amountController.removeListener(_listener);
    accountController.dispose();
    amountController.dispose();
    coefficientController.removeListener(_listener);
    coefficientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel(
      viewModel: this,
      useCases: [() => OnCurrencyLinkPressed(), () => OnSubmitPressed()],
      child: BalanceExchangeFormView(keyboardHeight: widget.keyboardHeight),
    );
  }
}
