import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/double.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/models.dart";

class AccountComponent extends StatelessWidget {
  final AccountModel account;
  final AccountBalanceModel? balance;
  final bool showCurrencyTag;
  final bool showColors;
  final bool showCents;

  const AccountComponent({
    super.key,
    required this.account,
    this.balance,
    this.showCurrencyTag = false,
    required this.showColors,
    this.showCents = true,
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

    return SeparatedComponent.list(
      direction: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(width: 10.0),
      children: [
        // -> icon
        SizedBox.square(
          dimension: iconDimension,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    showColors
                        ? [color2, color]
                        : [
                          theme.colorScheme.surfaceContainerHighest,
                          theme.colorScheme.surfaceContainer,
                        ],
              ),
              shape: SmoothRectangleBorder(
                side:
                    showColors
                        ? BorderSide.none
                        : BorderSide(color: theme.colorScheme.outlineVariant),
                borderRadius: const SmoothBorderRadius.all(
                  SmoothRadius(cornerRadius: 20.0, cornerSmoothing: 0.6),
                ),
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

        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.0,
            children: [
              // -> title
              Flexible(
                child: Row(
                  children: [
                    // -> currency tag
                    if (showCurrencyTag)
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
                      child: NumericText(
                        account.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.golosText(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                          color:
                              showColors ? color : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // -> type
              Flexible(
                child: NumericText(
                  account.type.description,
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
                Flexible(
                  child: NumericText(
                    balance.totalSum.currency(
                      locale: locale.languageCode,
                      name: balance.currency.name,
                      symbol: balance.currency.symbol,
                      showDecimal: showCents,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.golosText(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
