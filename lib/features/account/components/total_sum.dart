import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";

class AccountTotalSumComponent extends StatelessWidget {
  final AccountBalanceModel balance;

  const AccountTotalSumComponent({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -> title
        Text(
          "Баланс",
          style: GoogleFonts.golosText(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10.0),

        // -> sum
        Text(
          balance.totalSum.currency(
            name: balance.currency.name,
            symbol: balance.currency.symbol,
          ),
          style: GoogleFonts.golosText(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
