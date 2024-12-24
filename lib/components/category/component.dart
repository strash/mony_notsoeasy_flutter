import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/domain/models/category.dart";

class CategoryComponent extends StatelessWidget {
  final CategoryModel category;

  const CategoryComponent({super.key, required this.category});

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
      mainAxisSize: MainAxisSize.min,
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
                colors: [color2, color],
              ),
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(cornerRadius: 15.0, cornerSmoothing: 1.0),
                ),
              ),
            ),
            child: Center(
              child: Text(
                category.icon,
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
                child: Text(
                  category.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.golosText(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),

              // -> type
              Text(
                category.transactionType.fullDescription,
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
