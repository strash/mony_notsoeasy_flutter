import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/figma_squircle.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class CategoryComponent extends StatelessWidget {
  final CategoryModel category;
  final bool showColors;

  const CategoryComponent({
    super.key,
    required this.category,
    required this.showColors,
  });

  @override
  Widget build(BuildContext context) {
    final ex = Theme.of(context).extension<ColorExtension>();
    final colorScheme = ColorScheme.of(context);
    final color = ex?.from(category.colorName).color ?? colorScheme.onSurface;
    final color2 = Color.lerp(color, const Color(0xFFFFFFFF), .3)!;
    final colors = [
      colorScheme.surfaceContainerHighest,
      colorScheme.surfaceContainer,
    ];
    const iconDimension = 50.0;

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
                15.0,
                showColors
                    ? BorderSide.none
                    : BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Center(
              child: Text(
                category.icon,
                style: TextTheme.of(context).headlineMedium,
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
              Flexible(
                child: Text(
                  category.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.golosText(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: showColors ? color : colorScheme.onSurface,
                  ),
                ),
              ),

              // -> type
              Row(
                children: [
                  // -> icon
                  SvgPicture.asset(
                    category.transactionType.icon,
                    width: 16.0,
                    height: 16.0,
                    colorFilter: ColorFilter.mode(switch (category
                        .transactionType) {
                      ETransactionType.expense => colorScheme.error,
                      ETransactionType.income => colorScheme.secondary,
                    }, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 5.0),

                  // -> description
                  Flexible(
                    child: Text(
                      context.t.models.transaction.type_full_description(
                        context: category.transactionType,
                      ),
                      style: GoogleFonts.golosText(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
