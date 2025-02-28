import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account_select/component.dart";
import "package:mony_app/features/balance_exchange_form/components/account_select_active_entry.dart";
import "package:mony_app/features/balance_exchange_form/components/helper_text.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";

class BalanceExchangeFormAccountSelectComponent extends StatelessWidget {
  const BalanceExchangeFormAccountSelectComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccountSelectComponent(
          controller: viewModel.accountController,
          accounts: viewModel.accounts,
          isColorsVisible: viewModel.isColorsVisible,
          activeEntry: BalanceExchangeFormAccountSelectActiveEntryComponent(
            controller: viewModel.accountController,
            isColorsVisible: viewModel.isColorsVisible,
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 4.0, 15.0, .0),
          child: BalanceExchangeFormHelperTextComponent(
            text: viewModel.action.helperText,
          ),
        ),
      ],
    );
  }
}

extension on EBalanceExchangeMenuItem {
  String get helperText {
    return switch (this) {
      EBalanceExchangeMenuItem.receive => "Счет, с которого пополняем",
      EBalanceExchangeMenuItem.send => "Счет, на который переводим",
    };
  }
}
