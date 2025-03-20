import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/double.dart";
import "package:mony_app/common/extensions/figma_squircle.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/i18n/strings.g.dart";

class AccountComponent extends StatelessWidget {
  final AccountModel account;
  final AccountBalanceModel? balance;
  final bool showDecimal;
  final bool showColors;

  const AccountComponent({
    super.key,
    required this.account,
    this.balance,
    this.showDecimal = true,
    required this.showColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final color =
        ex?.from(account.colorName).color ?? theme.colorScheme.onSurface;
    final color2 = Color.lerp(color, const Color(0xFFFFFFFF), .3)!;
    const iconDimension = 50.0;

    final locale = Localizations.localeOf(context);
    final balance = this.balance;

    final colors = [
      theme.colorScheme.surfaceContainerHighest,
      theme.colorScheme.surfaceContainer,
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -> icon
        SizedBox.square(
          dimension: iconDimension,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: showColors ? [color2, color] : colors,
              ),
              shape: Smooth.border(
                23.0,
                showColors
                    ? BorderSide.none
                    : BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Center(
              child: Text(
                account.type.icon,
                style: theme.textTheme.headlineMedium,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10.0),

        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3.0,
            children: [
              // -> title
              Row(
                children: [
                  // -> currency tag
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0, right: 8.0),
                    child: CurrencyTagComponent(
                      code: account.currency.code,
                      background:
                          showColors
                              ? color
                              : theme.colorScheme.onSurfaceVariant,
                      foreground: theme.colorScheme.surface,
                    ),
                  ),

                  // -> title
                  Flexible(
                    child: Text(
                      account.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.golosText(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: showColors ? color : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),

              // -> type
              Flexible(
                child: Text(
                  context.t.models.account.type_description(
                    context: account.type,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.golosText(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              // -> balance
              if (balance != null)
                NumericText(
                  balance.totalSum.currency(
                    locale: locale.languageCode,
                    name: balance.currency.name,
                    symbol: balance.currency.symbol,
                    showDecimal: showDecimal,
                  ),
                  style: GoogleFonts.golosText(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
