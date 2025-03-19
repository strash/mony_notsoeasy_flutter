import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/balance_exchange_form/components/components.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";
import "package:mony_app/features/balance_exchange_form/use_case/on_submit_pressed.dart";
import "package:mony_app/i18n/strings.g.dart";

class BalanceExchangeFormView extends StatelessWidget {
  final double keyboardHeight;

  const BalanceExchangeFormView({super.key, required this.keyboardHeight});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();
    final action = viewModel.action;
    final isSameCurrency = viewModel.isSameCurrency;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -> appbar
        AppBarComponent(
          title: Text(
            context.t.features.balance_exchange_form.title(context: action),
          ),
          useSliver: false,
          showBackground: false,
          showDragHandle: true,
        ),

        // -> form
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Form(
            child: SeparatedComponent.list(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 20.0);
              },
              children: [
                // -> form elements
                SeparatedComponent.list(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10.0);
                  },
                  children: switch (action) {
                    // -> receive
                    EBalanceExchangeMenuItem.receive => [
                      const BalanceExchangeFormAccountSelectComponent(),
                      const BalanceExchangeFormAmountComponent(),
                      if (!isSameCurrency)
                        const BalanceExchangeFormConvertedAmountComponent(),
                    ],

                    // -> send
                    EBalanceExchangeMenuItem.send => [
                      const BalanceExchangeFormAmountComponent(),
                      if (!isSameCurrency)
                        const BalanceExchangeFormConvertedAmountComponent(),
                      const BalanceExchangeFormAccountSelectComponent(),
                    ],
                  },
                ),

                // -> submit
                FilledButton(
                  onPressed:
                      viewModel.isSubmitEnabled
                          ? () => viewModel<OnSubmitPressed>()(context)
                          : null,
                  child: Text(
                    context.t.features.balance_exchange_form.button_submit(
                      context: action,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 40.0 + keyboardHeight),
      ],
    );
  }
}
