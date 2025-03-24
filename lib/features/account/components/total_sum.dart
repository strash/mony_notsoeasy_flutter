import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/i18n/strings.g.dart";

class AccountTotalSumComponent extends StatelessWidget {
  final AccountBalanceModel balance;
  final bool showDecimal;

  const AccountTotalSumComponent({
    super.key,
    required this.balance,
    required this.showDecimal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final locale = Localizations.localeOf(context);

    return SeparatedComponent.list(
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      children: [
        // -> title
        Text(
          context.t.features.account.total_sum.title,
          style: GoogleFonts.golosText(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        // -> sum
        NumericText(
          balance.totalSum.currency(
            locale: locale.languageCode,
            name: balance.currency.name,
            symbol: balance.currency.symbol,
            showDecimal: showDecimal,
          ),
          style: GoogleFonts.golosText(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            height: 1.4,
            color: theme.colorScheme.onSurface,
            textStyle: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
