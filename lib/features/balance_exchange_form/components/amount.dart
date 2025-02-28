import "package:flutter/material.dart";
import "package:flutter/services.dart" show MaxLengthEnforcement;
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/constants.dart" show kMaxAmountLength;
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/currency_tag/component.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";

class BalanceExchangeFormAmountComponent extends StatelessWidget {
  const BalanceExchangeFormAmountComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();
    final left = viewModel.leftBalance;
    final showColors = viewModel.isColorsVisible;

    return Stack(
      children: [
        TextFormField(
          key: viewModel.amountController.key,
          focusNode: viewModel.amountController.focus,
          controller: viewModel.amountController.controller,
          validator: viewModel.amountController.validator,
          textAlign: TextAlign.end,
          onTapOutside: viewModel.amountController.onTapOutside,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          maxLength: kMaxAmountLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          autovalidateMode: AutovalidateMode.always,
          style: GoogleFonts.golosText(
            color: theme.colorScheme.onSurface,
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: viewModel.action.placeholder,
            counterText: "",
          ),
          onFieldSubmitted: viewModel.amountController.validator,
        ),

        if (left != null)
          Positioned(
            left: 15.0,
            top: 17.0,
            child: IgnorePointer(
              child: CurrencyTagComponent(
                code: left.currency.code,
                background:
                    showColors
                        ? viewModel.color(viewModel.leftAccount)
                        : theme.colorScheme.onSurfaceVariant,
                foreground: theme.colorScheme.surface,
              ),
            ),
          ),
      ],
    );
  }
}

extension on EBalanceExchangeMenuItem {
  String get placeholder {
    return switch (this) {
      EBalanceExchangeMenuItem.receive => "сумма для пополнения",
      EBalanceExchangeMenuItem.send => "сумма для перевода",
    };
  }
}
