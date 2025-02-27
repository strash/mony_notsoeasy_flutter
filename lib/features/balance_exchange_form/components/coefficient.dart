import "package:flutter/material.dart";
import "package:flutter/services.dart" show MaxLengthEnforcement;
import "package:flutter_svg/flutter_svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart" show ColorExtension;
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/common/extensions/double.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";
import "package:mony_app/features/balance_exchange_form/use_case/on_currency_link_pressed.dart";
import "package:mony_app/gen/assets.gen.dart";

class BalanceExchangeFormCoefficientComponent extends StatelessWidget {
  const BalanceExchangeFormCoefficientComponent({super.key});

  Color color(BuildContext context, AccountModel? account) {
    final theme = Theme.of(context);
    if (account == null) return theme.colorScheme.onSurface;
    final ex = theme.extension<ColorExtension>();
    return ex?.from(account.colorName).color ?? theme.colorScheme.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();
    final left = viewModel.leftBalance;
    final right = viewModel.rightBalance;

    final locale = Localizations.localeOf(context);
    final showColors = viewModel.isColorsVisible;

    final onLinkPressed = viewModel<OnCurrencyLinkPressed>();

    return Row(
      children: [
        // -> base
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onLinkPressed(context),
          child: Column(
            children: [
              SeparatedComponent.list(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                separatorBuilder:
                    (context, index) => const SizedBox(width: 6.0),
                children: [
                  // -> currency tag
                  if (left != null)
                    CurrencyTagComponent(
                      code: left.currency.code,
                      background:
                          showColors
                              ? color(context, viewModel.leftAccount)
                              : theme.colorScheme.onSurfaceVariant,
                      foreground: theme.colorScheme.surface,
                    ),

                  // -> unit
                  if (left != null)
                    Text(
                      1.0.currency(
                        name: left.currency.name,
                        symbol: left.currency.symbol,
                        locale: locale.languageCode,
                        showDecimal: false,
                      ),
                      style: GoogleFonts.golosText(
                        fontSize: 28.0,
                        height: 1.0,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),

                  // -> icon equal
                  SvgPicture.asset(
                    Assets.icons.equal,
                    width: 32.0,
                    height: 32.0,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.tertiary,
                      BlendMode.srcIn,
                    ),
                  ),

                  // -> currency tag
                  if (right != null)
                    CurrencyTagComponent(
                      code: right.currency.code,
                      background:
                          showColors
                              ? color(context, viewModel.rightAccount)
                              : theme.colorScheme.onSurfaceVariant,
                      foreground: theme.colorScheme.surface,
                    ),
                ],
              ),
              Text(
                "Посмотреть курс",
                style: GoogleFonts.golosText(
                  fontSize: 13.0,
                  height: 1.0,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.tertiary,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationColor: theme.colorScheme.tertiary,
                  decorationThickness: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10.0),

        // -> input
        Flexible(
          child: TextFormField(
            key: viewModel.coefficientController.key,
            focusNode: viewModel.coefficientController.focus,
            controller: viewModel.coefficientController.controller,
            validator: viewModel.coefficientController.validator,
            textAlign: TextAlign.end,
            onTapOutside: viewModel.coefficientController.onTapOutside,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            maxLength: 6,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            autovalidateMode: AutovalidateMode.always,
            style: GoogleFonts.golosText(
              color: theme.colorScheme.onSurface,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              hintText: "Коэффициент",
              counterText: "",
            ),
            onFieldSubmitted: viewModel.coefficientController.validator,
          ),
        ),
      ],
    );
  }
}
