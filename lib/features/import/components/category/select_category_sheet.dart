import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
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
    final bottom = MediaQuery.viewPaddingOf(context).bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(15.w, .0, 15.w, 40.h + bottom),
      child: Wrap(
        spacing: 8.r,
        runSpacing: 8.r,
        children: categories.map((e) {
          final (:bg, :border, :text) = getCategoryColors(context, e.color);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop<CategoryModel>(e),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: bg,
                shape: SmoothRectangleBorder(
                  side: BorderSide(color: border),
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(
                      cornerRadius: 10.r,
                      cornerSmoothing: 1.0,
                    ),
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
                      padding: EdgeInsets.only(right: 3.w),
                      child: Text(
                        e.icon,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                    ),

                    // -> title
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Text(
                          e.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.golosText(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: text,
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
