import "package:flutter/material.dart";
import "package:flutter/services.dart" show MaxLengthEnforcement;
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/constants.dart" show kMaxAmountLength;
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/currency_tag/component.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";
import "package:mony_app/i18n/strings.g.dart";

class BalanceExchangeFormAmountComponent extends StatelessWidget {
  const BalanceExchangeFormAmountComponent({super.key});

  @override
  Widget build(BuildContext context) {
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
            color: ColorScheme.of(context).onSurface,
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: context.t.features.balance_exchange_form
                .amount_input_placeholder(context: viewModel.action),
            counterText: "",
          ),
          onFieldSubmitted: viewModel.amountController.validator,
        ),

        if (left != null)
          Positioned(
            left: 12.0,
            top: 17.0,
            child: IgnorePointer(
              child: CurrencyTagComponent(
                code: left.currency.code,
                background:
                    showColors
                        ? viewModel.color(viewModel.leftAccount)
                        : ColorScheme.of(context).onSurfaceVariant,
                foreground: ColorScheme.of(context).surface,
              ),
            ),
          ),
      ],
    );
  }
}
