import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/balance_exchange_form/components/components.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";

class BalanceExchangeFormView extends StatelessWidget {
  final double keyboardHeight;

  const BalanceExchangeFormView({super.key, required this.keyboardHeight});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();
    final action = viewModel.action;
    final placeholder = action.placeholder;
    final isSameCurrency = viewModel.isSameCurrency;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -> appbar
        AppBarComponent(
          title: Text(action.title),
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
                      BalanceExchangeFormAmountComponent(
                        placeholder: placeholder,
                      ),
                      if (!isSameCurrency)
                        const BalanceExchangeFormCoefficientComponent(),
                    ],

                    // -> send
                    EBalanceExchangeMenuItem.send => [
                      BalanceExchangeFormAmountComponent(
                        placeholder: placeholder,
                      ),
                      if (!isSameCurrency)
                        const BalanceExchangeFormCoefficientComponent(),
                      const BalanceExchangeFormAccountSelectComponent(),
                    ],
                  },
                ),

                // -> submit
                FilledButton(
                  onPressed:
                      viewModel.isSubmitEnabled
                          ? () =>
                              {} //onSubmitPressed(context)
                          : null,
                  child: Text(action.submit),
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

extension on EBalanceExchangeMenuItem {
  String get title {
    return switch (this) {
      EBalanceExchangeMenuItem.receive => "Пополнение с",
      EBalanceExchangeMenuItem.send => "Перевод на",
    };
  }

  String get placeholder {
    return switch (this) {
      EBalanceExchangeMenuItem.receive => "Сумма для пополнения",
      EBalanceExchangeMenuItem.send => "Сумма для перевода",
    };
  }

  String get submit {
    return switch (this) {
      EBalanceExchangeMenuItem.receive => "Пополнить",
      EBalanceExchangeMenuItem.send => "Перевести",
    };
  }
}
