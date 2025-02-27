import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account/component.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";

class BalanceExchangeFormAccountComponent extends StatelessWidget {
  const BalanceExchangeFormAccountComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();
    final balance = viewModel.activeBalance;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -> account
        AccountComponent(
          account: viewModel.activeAccount,
          balance: balance,
          showColors: viewModel.isColorsVisible,
          showCurrencyTag: true,
          showCents: viewModel.isCentsVisible,
        ),
      ],
    );
  }
}
