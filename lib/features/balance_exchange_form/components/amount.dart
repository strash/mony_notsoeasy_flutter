import "package:flutter/material.dart";
import "package:flutter/services.dart" show MaxLengthEnforcement;
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/constants.dart" show kMaxAmountLength;
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";

class BalanceExchangeFormAmountComponent extends StatelessWidget {
  final String placeholder;

  const BalanceExchangeFormAmountComponent({
    super.key,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();

    return TextFormField(
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
      decoration: InputDecoration(hintText: placeholder, counterText: ""),
      onFieldSubmitted: viewModel.amountController.validator,
    );
  }
}
