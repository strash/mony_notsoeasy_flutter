import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/account.dart";

class AccountComponent extends StatelessWidget {
  final AccountModel account;
  final bool showCurrencyTag;
  final bool showColors;

  const AccountComponent({
    super.key,
    required this.account,
    this.showCurrencyTag = false,
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

    return SeparatedComponent.list(
      direction: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(width: 10.0),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // -> icon
        SizedBox.square(
          dimension: iconDimension,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              gradient:
                  showColors
                      ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [color2, color],
                      )
                      : null,
              shape: SmoothRectangleBorder(
                side: BorderSide(
                  color: theme.colorScheme.outline.withValues(
                    alpha: showColors ? .0 : 1.0,
                  ),
                ),
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
            children: [
              // -> title
              Flexible(
                child: Row(
                  children: [
                    // -> currency tag
                    if (showCurrencyTag)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, right: 8.0),
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
                          color:
                              showColors ? color : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // -> type
              Text(
                account.type.description,
                style: GoogleFonts.golosText(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
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
