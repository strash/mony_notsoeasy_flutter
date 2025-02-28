import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/gen/assets.gen.dart";

class CategoryIconComponent extends StatelessWidget {
  final CategoryModel category;
  final bool showColors;

  const CategoryIconComponent({
    super.key,
    required this.category,
    required this.showColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final color =
        ex?.from(category.colorName).color ?? theme.colorScheme.onSurface;
    final color2 = Color.lerp(color, const Color(0xFFFFFFFF), .3)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -> icon
        Center(
          child: SizedBox.square(
            dimension: 100.0,
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
                    SmoothRadius(cornerRadius: 30.0, cornerSmoothing: 0.6),
                  ),
                ),
              ),
              child: Center(
                child: Text(category.icon, style: theme.textTheme.displayLarge),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),

        // -> title
        Text(
          category.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.golosText(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: showColors ? color : theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2.0),

        // -> subtitle
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // -> icon
            SvgPicture.asset(
              category.transactionType.icon,
              width: 16.0,
              height: 16.0,
              colorFilter: ColorFilter.mode(switch (category.transactionType) {
                ETransactionType.expense => theme.colorScheme.error,
                ETransactionType.income => theme.colorScheme.secondary,
              }, BlendMode.srcIn),
            ),
            const SizedBox(width: 5.0),

            // -> description
            Text(
              category.transactionType.fullDescription,
              textAlign: TextAlign.center,
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

extension on ETransactionType {
  String get icon {
    return switch (this) {
      ETransactionType.expense => Assets.icons.arrowUpForwardSemibold,
      ETransactionType.income => Assets.icons.arrowDownForwardSemibold,
    };
  }
}
