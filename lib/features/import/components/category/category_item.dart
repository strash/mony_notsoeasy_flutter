import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/utils/color/color.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/import/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class ImportCategoryItemComponent extends StatelessWidget {
  final ETransactionType transactionType;
  final TMappedCategory category;
  final UseCase<Future<void>, TPressedCategoryValue> onTap;
  final UseCase<void, TPressedCategoryValue> onReset;

  const ImportCategoryItemComponent({
    super.key,
    required this.transactionType,
    required this.category,
    required this.onTap,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = (transactionType: transactionType, category: category);
    final Color bg;
    final Color border;
    final Color text;
    final String? icon;
    final String title;
    if (category.linkedModel != null) {
      (:bg, :border, :text) =
          getCategoryColors(context, category.linkedModel!.color);
      icon = category.linkedModel!.icon;
      title = category.linkedModel!.title;
    } else if (category.vo != null) {
      (:bg, :border, :text) = getCategoryColors(context, category.vo!.color);
      icon = category.vo!.icon;
      title = category.vo!.title;
    } else {
      bg = theme.colorScheme.surfaceContainer;
      border = theme.colorScheme.tertiaryContainer;
      text = theme.colorScheme.onSurface;
      icon = null;
      title = category.title;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(context, value),
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
          padding: EdgeInsets.only(
            left: icon != null ? 10.w : 15.w,
            right: icon != null ? .0 : 15.w,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // -> icon
              if (icon != null)
                Padding(
                  padding: EdgeInsets.only(right: 3.w),
                  child: Text(
                    icon,
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
                    title,
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

              if (icon != null)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onReset(context, value),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 6.h, 10.w, 6.h),
                    child: SvgPicture.asset(
                      Assets.icons.xmark,
                      width: 20.r,
                      height: 20.r,
                      colorFilter: ColorFilter.mode(text, BlendMode.srcIn),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
