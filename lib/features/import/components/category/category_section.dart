import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class ImportCategorySectionComponent extends StatelessWidget {
  final ETransactionType transactionType;
  final List<ImportModelCategoryVO> categories;
  final UseCase<Future<void>, ImportModelCategoryVO> onTap;
  final UseCase<void, ImportModelCategoryVO> onReset;

  const ImportCategorySectionComponent({
    super.key,
    required this.transactionType,
    required this.categories,
    required this.onTap,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = switch (transactionType) {
      ETransactionType.expense => "расходов",
      ETransactionType.income => "доходов",
    };
    final count = categories.fold<int>(0, (prev, e) {
      return prev + (e is ImportModelCategoryVOEmpty ? 0 : 1);
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // -> icon
              if (count == categories.length)
                Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: SvgPicture.asset(
                    Assets.icons.checkmarkCircleFill,
                    width: 20.r,
                    height: 20.r,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.secondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),

              // -> title
              Text(
                "Категории $title $count/${categories.length}",
                style: GoogleFonts.golosText(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // -> categories
          Wrap(
            spacing: 8.r,
            runSpacing: 8.r,
            children: categories.map((e) {
              return ImportCategoryItemComponent(
                category: e,
                onTap: onTap,
                onReset: onReset,
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}
