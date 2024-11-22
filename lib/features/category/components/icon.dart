import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/gen/assets.gen.dart";

class CategoryIconComponent extends StatelessWidget {
  final CategoryModel category;

  const CategoryIconComponent({super.key, required this.category});

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
                  colors: [color2, color],
                ),
                shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 30.0, cornerSmoothing: 1.0),
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  category.icon,
                  style: theme.textTheme.displayLarge,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),

        Row(
          mainAxisSize: MainAxisSize.min,
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

            // -> icon
            Padding(
              padding: const EdgeInsets.only(left: 2.0, top: 1.0),
              child: SvgPicture.asset(
                Assets.icons.chevronForward,
                width: 20.0,
                height: 20.0,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
