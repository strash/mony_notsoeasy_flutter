import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/domain/domain.dart";

class AccountCurrencyComponent extends StatelessWidget {
  final AccountBalanceModel balance;

  const AccountCurrencyComponent({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SeparatedComponent.list(
      separatorBuilder: (context) => const SizedBox(height: 10.0),
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
        Text(
          "${balance.currency.code}"
          " • "
          "${balance.currency.name}",
          style: GoogleFonts.golosText(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
