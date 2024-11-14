import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/domain.dart";

class ImportCategorySelectBottomSheetCotponent extends StatelessWidget {
  final List<CategoryModel> categories;

  const ImportCategorySelectBottomSheetCotponent({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final bottom = MediaQuery.viewPaddingOf(context).bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(15.w, .0, 15.w, 40.h + bottom),
      child: Wrap(
        spacing: 8.r,
        runSpacing: 8.r,
        children: categories.map((e) {
          final color =
              ex?.from(e.colorName).color ?? theme.colorScheme.surfaceContainer;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop<CategoryModel>(e),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: color.withOpacity(.25),
                shape: SmoothRectangleBorder(
                  side: BorderSide(color: color),
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 10.r, cornerSmoothing: 1.0),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10.w, right: 15.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // -> icon
                    Padding(
                      padding: EdgeInsets.only(right: 3.w, bottom: 1.h),
                      child: Text(
                        e.icon,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: .0,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),

                    // -> title
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.h, bottom: 7.h),
                        child: Text(
                          e.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.golosText(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}
