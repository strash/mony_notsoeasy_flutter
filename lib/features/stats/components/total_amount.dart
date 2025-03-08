import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/features/stats/page/view_model.dart";

class StatsTotalAmountComponent extends StatelessWidget {
  const StatsTotalAmountComponent({super.key});

  String _getCount(String locale, int count) {
    final formatter = NumberFormat.decimalPattern(locale);
    final formatted = formatter.format(count);
    return switch (count.wordCaseHint) {
      EWordCaseHint.nominative => "$formatted транзакция",
      EWordCaseHint.genitive => "$formatted транзакции",
      EWordCaseHint.accusative => "$formatted транзакций",
    };
  }

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
    final amount = _getAmount(
      locale.languageCode,
      account,
      balance,
      viewModel.isCentsVisible,
    );
    final count = _getCount(locale.languageCode, balance?.totalCount ?? 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: constraints,
          child: SeparatedComponent.list(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 6.0);
            },
            children: [
              // -> amount
              FittedBox(
                child: NumericText(
                  amount,
                  style: GoogleFonts.golosText(
                    fontSize: 28.0,
                    height: 1.0,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),

              // -> count
              Flexible(
                child: NumericText(
                  count,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.golosText(
                    fontSize: 14.0,
                    height: 1.0,
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
