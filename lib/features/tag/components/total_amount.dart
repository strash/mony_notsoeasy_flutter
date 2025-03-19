import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/domain/models/tag_balance.dart";
import "package:mony_app/i18n/strings.g.dart";

class TagTotalAmountComponent extends StatelessWidget {
  final TagBalanceModel balance;
  final bool showDecimal;

  const TagTotalAmountComponent({
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
          context.t.features.tag.total_amount.title,
          style: GoogleFonts.golosText(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        // -> amount
        SeparatedComponent.builder(
          itemCount: balance.totalAmount.entries.length,
          separatorBuilder: (context, index) => const SizedBox(height: 3.0),
          itemBuilder: (context, index) {
            final MapEntry(key: currency, value: totalAmount) = balance
                .totalAmount
                .entries
                .elementAt(index);

            return NumericText(
              totalAmount.currency(
                locale: locale.languageCode,
                name: currency.name,
                symbol: currency.symbol,
                showDecimal: showDecimal,
              ),
              style: GoogleFonts.golosText(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: theme.colorScheme.onSurface,
              ),
            );
          },
        ),

        SeparatedComponent.list(
          separatorBuilder: (context, index) => const SizedBox(height: 3.0),
          children: [
            // -> transactions count
            Text(
              context.t.models.transaction.transactions_count_description(
                n: balance.transactionsCount,
              ),
              style: GoogleFonts.golosText(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            // -> transactions date range
            Text(
              (
                balance.firstTransactionDate,
                balance.lastTransactionDate,
              ).transactionsDateRangeDescription(locale.languageCode),
              style: GoogleFonts.golosText(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
