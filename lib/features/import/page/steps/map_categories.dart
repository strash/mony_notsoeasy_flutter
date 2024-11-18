import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/components/category/category_section.dart";

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
    final onCategoryPressed = viewModel<OnCategoryButtonPressed>();
    final onCategoryResetPressed = viewModel<OnCategoryResetPressed>();

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
        ValueListenableBuilder(
          valueListenable: categoryModel.mappedCategories,
          builder: (context, categories, child) {
            final filtered =
                categories.entries.where((e) => e.value.isNotEmpty);

            return SeparatedComponent(
              itemCount: filtered.length,
              separatorBuilder: (context) => SizedBox(height: 40.h),
              itemBuilder: (context, index) {
                final MapEntry(:key, :value) = filtered.elementAt(index);

                return ImportCategorySectionComponent(
                  transactionType: key.transactionType,
                  categories: value,
                  onTap: onCategoryPressed,
                  onReset: onCategoryResetPressed,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
