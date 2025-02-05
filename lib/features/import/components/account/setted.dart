import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/domain.dart";

class AccountSettedItemComponent extends StatelessWidget {
  final AccountVO account;

  const AccountSettedItemComponent({required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();

    final locale = Localizations.localeOf(context);
    final formatter = NumberFormat.compact(locale: locale.languageCode);

    final color = ex?.from(EColorName.from(account.colorName)).color ??
        theme.colorScheme.onSurface;

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

                // -> account type
                Text(
                  "${account.currencyCode} • ${account.type.description}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.golosText(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20.0),

          // -> balance with currency
          Text(
            formatter.format(account.balance),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.golosText(
              fontSize: 16.0,
              height: 1.0,
              fontWeight: FontWeight.w500,
              color: account.balance >= 0.0
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
