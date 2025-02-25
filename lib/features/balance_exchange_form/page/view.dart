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
    final theme = Theme.of(context);

    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();
    final action = viewModel.action;

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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Form(
            child: SeparatedComponent.list(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10.0);
              },
              children: [
                // -> active account and account select
                switch (action) {
                  EBalanceExchangeMenuItem.receive =>
                    const BalanceExchangeFormReceiveOrderComponent(),
                  EBalanceExchangeMenuItem.send =>
                    const BalanceExchangeFormSendOrderComponent(),
                },

                // -> submit
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FilledButton(
                    onPressed:
                        viewModel.isSubmitEnabled
                            ? () =>
                                {} //onSubmitPressed(context)
                            : null,
                    child: Text(action.submit),
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

extension on EBalanceExchangeMenuItem {
  String get title {
    return switch (this) {
      EBalanceExchangeMenuItem.receive => "Пополнение",
      EBalanceExchangeMenuItem.send => "Перевод",
    };
  }

  String get submit {
    return switch (this) {
      EBalanceExchangeMenuItem.receive => "Пополнить",
      EBalanceExchangeMenuItem.send => "Перевести",
    };
  }
}
