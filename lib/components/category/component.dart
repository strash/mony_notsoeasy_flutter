import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/gen/assets.gen.dart";

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
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final color =
        ex?.from(category.colorName).color ?? theme.colorScheme.onSurface;
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
                  SmoothRadius(cornerRadius: 15.0, cornerSmoothing: 0.6),
                ),
              ),
            ),
            child: Center(
              child: Text(category.icon, style: theme.textTheme.headlineMedium),
            ),
          ),
        ),

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
                    color: showColors ? color : theme.colorScheme.onSurface,
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
                      ETransactionType.expense => theme.colorScheme.error,
                      ETransactionType.income => theme.colorScheme.secondary,
                    }, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 5.0),

                  // -> description
                  Flexible(
                    child: Text(
                      category.transactionType.fullDescription,
                      style: GoogleFonts.golosText(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurfaceVariant,
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
