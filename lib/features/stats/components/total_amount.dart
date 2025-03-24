import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:mony_app/i18n/strings.g.dart";

class StatsTotalAmountComponent extends StatelessWidget {
  const StatsTotalAmountComponent({super.key});

  String _getAmount(
    String locale,
    AccountModel? account,
    AccountBalanceModel? balance,
    bool showDecimal,
  ) {
    if (account == null || balance == null) return "0";
    return balance.totalAmount.currency(
      locale: locale,
      name: account.currency.name,
      symbol: account.currency.symbol,
      showDecimal: showDecimal,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final locale = Localizations.localeOf(context);

    final viewModel = context.viewModel<StatsViewModel>();
    final account = viewModel.accountController.value;
    final balance = viewModel.balance;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: constraints,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // -> amount
              FittedBox(
                child: NumericText(
                  _getAmount(
                    locale.languageCode,
                    account,
                    balance,
                    viewModel.isCentsVisible,
                  ),
                  style: GoogleFonts.golosText(
                    fontSize: 28.0,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                    textStyle: theme.textTheme.bodyMedium,
                  ),
                ),
              ),

              // -> count
              Flexible(
                child: Text(
                  context.t.features.stats.transactions_count(
                    n: balance?.totalCount ?? 0,
                  ),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.golosText(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
