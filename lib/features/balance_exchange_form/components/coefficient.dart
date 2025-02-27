import "package:flutter/material.dart";
import "package:flutter/services.dart" show MaxLengthEnforcement;
import "package:flutter_svg/flutter_svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart" show ColorExtension;
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/common/extensions/double.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/models/account_balance.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class BalanceExchangeFormCoefficientComponent extends StatelessWidget {
  const BalanceExchangeFormCoefficientComponent({super.key});

  AccountModel? leftAccount(BalanceExchangeFormViewModel viewModel) {
    return switch (viewModel.action) {
      EBalanceExchangeMenuItem.receive => viewModel.accountController.value,
      EBalanceExchangeMenuItem.send => viewModel.activeAccount,
    };
  }

  AccountModel? rightAccount(BalanceExchangeFormViewModel viewModel) {
    return switch (viewModel.action) {
      EBalanceExchangeMenuItem.receive => viewModel.activeAccount,
      EBalanceExchangeMenuItem.send => viewModel.accountController.value,
    };
  }

  AccountBalanceModel? leftBalance(BalanceExchangeFormViewModel viewModel) {
    return switch (viewModel.action) {
      EBalanceExchangeMenuItem.receive => viewModel.selectedBalance,
      EBalanceExchangeMenuItem.send => viewModel.activeBalance,
    };
  }

  AccountBalanceModel? rightBalance(BalanceExchangeFormViewModel viewModel) {
    return switch (viewModel.action) {
      EBalanceExchangeMenuItem.receive => viewModel.activeBalance,
      EBalanceExchangeMenuItem.send => viewModel.selectedBalance,
    };
  }

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
    final left = leftBalance(viewModel);
    final right = rightBalance(viewModel);

    final locale = Localizations.localeOf(context);
    final showColors = viewModel.isColorsVisible;

    return SeparatedComponent.list(
      direction: Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      separatorBuilder: (context, index) => const SizedBox(width: 8.0),
      children: [
        // -> base
        if (left != null)
          // -> currency tag
          CurrencyTagComponent(
            code: left.currency.code,
            background:
                showColors
                    ? color(context, leftAccount(viewModel))
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
            textAlign: TextAlign.end,
            style: GoogleFonts.golosText(
              fontSize: 30.0,
              height: 1.0,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.tertiary,
            ),
          ),

        // -> icon equal
        SvgPicture.asset(
          Assets.icons.equal,
          width: 36.0,
          height: 36.0,
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
                    ? color(context, rightAccount(viewModel))
                    : theme.colorScheme.onSurfaceVariant,
            foreground: theme.colorScheme.surface,
          ),

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
