import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/components/category/category_block.dart";

class ImportMapCategoriesPage extends StatelessWidget {
  final ImportEvent? event;

  const ImportMapCategoriesPage({
    super.key,
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<ImportViewModel>();
    final categoryModel = viewModel.currentStep;
    if (categoryModel is! ImportModelCategory) {
      throw ArgumentError.value(categoryModel);
    }
    final categories = categoryModel.mappedCategories;
    final onCategoryPressed = viewModel<OnCategoryButtonPressed>();
    final onCategoryReseted = viewModel<OnCategoryResetPressed>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -> title
              Text(
                "Категории",
                style: GoogleFonts.golosText(
                  fontSize: 20.sp,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15.h),

              // -> description
              Text(
                "Я нашел ${categoryModel.numberOfCategoriesDescription}. "
                "Их нужно привязать к предустановленным категориям, "
                "либо дополнить информацией.",
                style: GoogleFonts.golosText(
                  fontSize: 15.sp,
                  height: 1.3.sp,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40.h),

        // -> categories
        SeparatedComponent(
          itemCount: categories.entries.where((e) => e.value.isNotEmpty).length,
          separatorBuilder: (context) => SizedBox(height: 30.h),
          itemBuilder: (context, index) {
            final MapEntry(key: type, value: list) = categories.entries
                .where((e) => e.value.isNotEmpty)
                .elementAt(index);

            return ImportCategoryBlockComponent(
              transactionType: type.type,
              categories: list,
              onTap: onCategoryPressed,
              onReset: onCategoryReseted,
            );
          },
        ),
      ],
    );
  }
}
