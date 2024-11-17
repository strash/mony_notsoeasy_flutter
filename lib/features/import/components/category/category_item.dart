import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/import/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class ImportCategoryItemComponent extends StatelessWidget {
  final ETransactionType transactionType;
  final ImportModelCategoryVO category;
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
    final ex = theme.extension<ColorExtension>();
    final value = (transactionType: transactionType, category: category);
    final Color bg;
    final Color border;
    final Color text = theme.colorScheme.onSurface;
    final String? icon;
    final String title;
    switch (category) {
      case ImportModelCategoryVOModel(title: _, model: final model)
          when model != null:
        final color = ex?.from(model.colorName).color ??
            theme.colorScheme.surfaceContainer;
        bg = color.withOpacity(.25);
        border = color;
        icon = model.icon;
        title = model.title;
      case ImportModelCategoryVOVO(title: _, vo: final vo) when vo != null:
        final color = ex?.from(EColorName.from(vo.colorName)).color ??
            theme.colorScheme.surfaceContainer;
        bg = color.withOpacity(.25);
        border = color;
        icon = vo.icon;
        title = vo.title;
      default:
        bg = theme.colorScheme.surfaceContainer;
        border = const Color(0x00FFFFFF);
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
              SmoothRadius(cornerRadius: 10.r, cornerSmoothing: 1.0),
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
                  padding: EdgeInsets.only(right: 3.w, bottom: 1.h),
                  child: Text(
                    icon,
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
