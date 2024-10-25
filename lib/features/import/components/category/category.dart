import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/import/page/view_model.dart";

class ImportCategoryItemComponent extends StatelessWidget {
  final ETransactionType transactionType;
  final List<TMappedCategory> categories;
  final UseCase<void, TPressedCategoryValue> onTap;

  const ImportCategoryItemComponent({
    super.key,
    required this.transactionType,
    required this.categories,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title =
        transactionType == ETransactionType.expense ? "расходов" : "доходов";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -> title
          Text(
            "Категории $title",
            style: GoogleFonts.golosText(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.tertiary,
            ),
          ),
          SizedBox(height: 10.h),

          // -> categories
          Wrap(
            spacing: 8.r,
            runSpacing: 8.r,
            children: categories.map((e) {
              final value = (transactionType: transactionType, category: e);

              return GestureDetector(
                onTap: () => onTap(context, value),
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    shape: SmoothRectangleBorder(
                      side: BorderSide(
                        color: theme.colorScheme.tertiaryContainer,
                      ),
                      borderRadius: SmoothBorderRadius.all(
                        SmoothRadius(
                          cornerRadius: 10.r,
                          cornerSmoothing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 6.h,
                    ),
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
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}
