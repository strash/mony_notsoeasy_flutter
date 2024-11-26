import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/domain/domain.dart";

class CategoryTotalAmountComponent extends StatelessWidget {
  final CategoryBalanceModel balance;

  const CategoryTotalAmountComponent({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        SeparatedComponent.builder(
          itemCount: balance.totalAmount.entries.length,
          separatorBuilder: (context, index) => const SizedBox(height: 3.0),
          itemBuilder: (context, index) {
            final MapEntry(key: currency, value: totalAmount) =
                balance.totalAmount.entries.elementAt(index);

            return Text(
              totalAmount.currency(
                name: currency.name,
                symbol: currency.symbol,
              ),
              style: GoogleFonts.golosText(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
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
              balance.transactionsCount.transactionsCountDescription,
              style: GoogleFonts.golosText(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            // -> transactions date range
            Text(
              (
                lhs: balance.firstTransactionDate,
                rhs: balance.lastTransactionDate
              ).transactionsDateRangeDescription,
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
