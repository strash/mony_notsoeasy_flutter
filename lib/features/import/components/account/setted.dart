import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/i18n/strings.g.dart";

class AccountSettedItemComponent extends StatelessWidget {
  final AccountVO account;

  const AccountSettedItemComponent({required this.account});

  @override
  Widget build(BuildContext context) {
    final ex = Theme.of(context).extension<ColorExtension>();

    final locale = Localizations.localeOf(context);
    final formatter = NumberFormat.compact(locale: locale.languageCode);

    final colorScheme = ColorScheme.of(context);
    final color =
        ex?.from(EColorName.from(account.colorName)).color ??
        colorScheme.onSurface;

    final accountTypeDescription = context.t.models.account.type_description(
      context: account.type,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -> title
                Text(
                  account.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.golosText(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 5.0),

                Row(
                  children: [
                    // -> currency tag
                    CurrencyTagComponent(code: account.currencyCode),

                    // -> account type
                    Flexible(
                      child: Text(
                        " • $accountTypeDescription",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.golosText(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20.0),

          // -> balance with currency
          NumericText(
            formatter.format(account.balance),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.golosText(
              fontSize: 16.0,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color:
                  account.balance >= 0.0
                      ? colorScheme.secondary
                      : colorScheme.error,
              textStyle: TextTheme.of(context).bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
