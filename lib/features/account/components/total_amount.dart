import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";

class AccountTotalAmountComponent extends StatelessWidget {
  final AccountBalanceModel balance;
  final bool showDecimal;

  const AccountTotalAmountComponent({
    super.key,
    required this.balance,
    required this.showDecimal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateRange = (
      lhs: balance.firstTransactionDate,
      rhs: balance.lastTransactionDate
    ).transactionsDateRangeDescription;

    return SeparatedComponent.list(
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      children: [
        // -> title
        Text(
          "Сумма транзакций",
          style: GoogleFonts.golosText(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        // -> amount
        Text(
          balance.totalAmount.currency(
            name: balance.currency.name,
            symbol: balance.currency.symbol,
            showDecimal: showDecimal,
          ),
          style: GoogleFonts.golosText(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),

        SeparatedComponent.list(
          separatorBuilder: (context, index) => const SizedBox(height: 3.0),
          children: [
            // -> transactions count
            Text(
              balance.transactionsCount.transactionsCountDescription,
              style: GoogleFonts.golosText(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            // -> transactions date range
            if (dateRange.isNotEmpty)
              Text(
                dateRange,
                style: GoogleFonts.golosText(
                  fontSize: 15.0,
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
