import "package:flutter/material.dart";
import "package:mony_app/app/theme/theme.dart" show ColorExtension;
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account_select/component.dart"
    show IAccountSelectActiveEntryComponent;
import "package:mony_app/components/currency_tag/component.dart";
import "package:mony_app/domain/models/account_balance.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";

class BalanceExchangeFormAccountSelectActiveEntryComponent
    extends IAccountSelectActiveEntryComponent {
  const BalanceExchangeFormAccountSelectActiveEntryComponent({
    required super.controller,
    required super.isColorsVisible,
  });

  @override
  Widget build(BuildContext context) {
    final value = controller.value;
    if (value == null) return const SizedBox();

    final ex = Theme.of(context).extension<ColorExtension>();
    final colorScheme = ColorScheme.of(context);
    final color = ex?.from(value.colorName).color ?? colorScheme.primary;

    final locale = Localizations.localeOf(context);
    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();
    final balance = viewModel.selectedBalance;

    return Row(
      children: [
        // -> currency tag
        Padding(
          padding: const EdgeInsets.only(top: 2.0, right: 6.0),
          child: CurrencyTagComponent(
            code: value.currency.code,
            background: isColorsVisible ? color : colorScheme.onSurfaceVariant,
            foreground: colorScheme.surface,
          ),
        ),

        // -> title
        Expanded(
          child: Text(
            value.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DefaultTextStyle.of(context).style.copyWith(
              color: isColorsVisible ? color : colorScheme.onSurface,
            ),
          ),
        ),

        // -> balance
        if (balance != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              balance.totalSum.currency(
                locale: locale.languageCode,
                name: balance.currency.name,
                symbol: balance.currency.symbol,
                showDecimal: viewModel.isCentsVisible,
              ),
              textAlign: TextAlign.end,
              style: DefaultTextStyle.of(
                context,
              ).style.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
      ],
    );
  }
}
