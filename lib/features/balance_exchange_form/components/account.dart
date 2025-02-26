import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account/component.dart";
import "package:mony_app/domain/models/account_balance.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";

class BalanceExchangeFormAccountComponent extends StatelessWidget {
  const BalanceExchangeFormAccountComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final locale = Localizations.localeOf(context);
    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();
    final balance = viewModel.activeBalance;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -> account
        AccountComponent(
          account: viewModel.activeAccount,
          showColors: viewModel.isColorsVisible,
          showCurrencyTag: true,
        ),

        // -> balance
        if (balance != null)
          Padding(
            padding: const EdgeInsets.only(left: 60.0),
            child: Text(
              balance.totalSum.currency(
                locale: locale.languageCode,
                name: balance.currency.name,
                symbol: balance.currency.symbol,
                showDecimal: viewModel.isCentsVisible,
              ),
              textAlign: TextAlign.end,
              style: GoogleFonts.golosText(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
