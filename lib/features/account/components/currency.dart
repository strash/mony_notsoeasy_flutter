import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";

class AccountCurrencyComponent extends StatelessWidget {
  final AccountBalanceModel balance;
  final (String, String) currencyDescription;
  final Color color;
  final bool showColors;

  const AccountCurrencyComponent({
    super.key,
    required this.balance,
    required this.currencyDescription,
    required this.color,
    required this.showColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SeparatedComponent.list(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      separatorBuilder: (context, index) {
        return Text(
          " • ",
          style: GoogleFonts.golosText(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        );
      },
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: CurrencyTagComponent(
            code: balance.currency.code,
            background: showColors ? color : theme.colorScheme.onSurfaceVariant,
            foreground: theme.colorScheme.surface,
          ),
        ),
        Flexible(
          child: Text.rich(
            TextSpan(
              text: currencyDescription.$2,
              children: [
                TextSpan(
                  text: " ${currencyDescription.$1}",
                  style: GoogleFonts.golosText(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            style: GoogleFonts.golosText(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
