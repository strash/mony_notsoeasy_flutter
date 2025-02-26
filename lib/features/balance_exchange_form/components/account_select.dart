import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account_select/component.dart";
import "package:mony_app/features/balance_exchange_form/components/account_select_active_entry.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";

class BalanceExchangeFormAccountSelectComponent extends StatelessWidget {
  const BalanceExchangeFormAccountSelectComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();

    return AccountSelectComponent(
      controller: viewModel.accountController,
      accounts: viewModel.accounts,
      isColorsVisible: viewModel.isColorsVisible,
      activeEntry: BalanceExchangeFormAccountSelectActiveEntryComponent(
        controller: viewModel.accountController,
        isColorsVisible: viewModel.isColorsVisible,
      ),
    );
  }
}
