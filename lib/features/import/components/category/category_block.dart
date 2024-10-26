import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/page/view_model.dart";

class ImportCategoryBlockComponent extends StatelessWidget {
  final ETransactionType transactionType;
  final List<TMappedCategory> categories;
  final UseCase<Future<void>, TPressedCategoryValue> onTap;
  final UseCase<void, TPressedCategoryValue> onReset;

  const ImportCategoryBlockComponent({
    super.key,
    required this.transactionType,
    required this.categories,
    required this.onTap,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title =
        transactionType == ETransactionType.expense ? "расходов" : "доходов";
    final count = categories.fold<int>(0, (prev, e) {
      final hasCategory = e.linkedModel != null || e.vo != null;
      return prev + (hasCategory ? 1 : 0);
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -> title
          Text(
            "Категории $title $count/${categories.length}",
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
              return ImportCategoryItemComponent(
                transactionType: transactionType,
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
