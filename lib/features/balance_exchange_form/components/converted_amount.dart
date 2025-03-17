import "package:flutter/material.dart";
import "package:flutter/services.dart" show MaxLengthEnforcement;
import "package:flutter_svg/flutter_svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/constants.dart" show kMaxAmountLength;
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/balance_exchange_form/components/helper_text.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";
import "package:mony_app/features/balance_exchange_form/use_case/on_currency_link_pressed.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class BalanceExchangeFormConvertedAmountComponent extends StatelessWidget {
  const BalanceExchangeFormConvertedAmountComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();
    final right = viewModel.rightBalance;
    final isColorsVisible = viewModel.isColorsVisible;
    final isConvertEnabled = viewModel.isConvertEnabled;

    final onLinkPressed = viewModel<OnCurrencyLinkPressed>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -> input
        Flexible(
          child: Stack(
            children: [
              TextFormField(
                key: viewModel.coefficientController.key,
                focusNode: viewModel.coefficientController.focus,
                controller: viewModel.coefficientController.controller,
                validator: viewModel.coefficientController.validator,
                textAlign: TextAlign.end,
                onTapOutside: viewModel.coefficientController.onTapOutside,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
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
                  hintText:
                      context
                          .t
                          .features
                          .balance_exchange_form
                          .converted_amount_input_placeholder,
                  counterText: "",
                  helper: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: BalanceExchangeFormHelperTextComponent(
                      text: context.t.features.balance_exchange_form
                          .converted_amount_input_description(
                            context: viewModel.action,
                          ),
                    ),
                  ),
                ),
                onFieldSubmitted: viewModel.coefficientController.validator,
              ),

              // -> currency tag
              if (right != null)
                Positioned(
                  left: 15.0,
                  top: 17.0,
                  child: IgnorePointer(
                    child: CurrencyTagComponent(
                      code: right.currency.code,
                      background:
                          isColorsVisible
                              ? viewModel.color(viewModel.rightAccount)
                              : theme.colorScheme.onSurfaceVariant,
                      foreground: theme.colorScheme.surface,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 5.0),

        // -> button go convert somewhere
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isConvertEnabled ? () => onLinkPressed(context) : null,
          child: AnimatedOpacity(
            opacity: isConvertEnabled ? 1.0 : .3,
            duration: Durations.short3,
            child: SizedBox.square(
              dimension: 48.0,
              child: Center(
                child: SvgPicture.asset(
                  Assets.icons.equal,
                  width: 32.0,
                  height: 32.0,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.tertiary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
