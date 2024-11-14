import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/domain/models/category.dart";

class TransactionCategoryComponent extends StatelessWidget {
  final CategoryModel category;

  const TransactionCategoryComponent({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final categoryColor =
        ex?.from(category.colorName).color ?? theme.colorScheme.onSurface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -> icon
        Center(
          child: SizedBox.square(
            dimension: 100.r,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.lerp(
                      categoryColor,
                      const Color(0xFFFFFFFF),
                      .3,
                    )!,
                    categoryColor,
                  ],
                ),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(
                      cornerRadius: 30.r,
                      cornerSmoothing: 1.0,
                    ),
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
        SizedBox(height: 10.h),

        // -> title
        Flexible(
          child: Text(
            category.title,
            style: GoogleFonts.golosText(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: categoryColor,
            ),
          ),
        ),
      ],
    );
  }
}
