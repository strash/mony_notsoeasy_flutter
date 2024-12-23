import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";

class AccountCurrencyComponent extends StatelessWidget {
  final AccountBalanceModel balance;
  final Color color;

  const AccountCurrencyComponent({
    super.key,
    required this.balance,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SeparatedComponent.list(
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      children: [
        // -> title
        Text(
          "Валюта",
          style: GoogleFonts.golosText(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        // -> currency
        SeparatedComponent.list(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          separatorBuilder: (context, index) {
            return Text(
              " • ",
              style: GoogleFonts.golosText(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            );
          },
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: CurrencyTagComponent(
                code: balance.currency.code,
                background: color,
                foreground: theme.colorScheme.surface,
              ),
            ),
            Text(
              balance.currency.name,
              style: GoogleFonts.golosText(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
