import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/figma_squircle.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

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
    final colors = [
      theme.colorScheme.surfaceContainerHighest,
      theme.colorScheme.surfaceContainer,
    ];

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
                  colors: showColors ? [color2, color] : colors,
                ),
                shape: Smooth.border(
                  30.0,
                  showColors
                      ? BorderSide.none
                      : BorderSide(color: theme.colorScheme.outlineVariant),
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
              context.t.models.transaction.type_full_description(
                context: category.transactionType,
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.golosText(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
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
