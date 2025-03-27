import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/components/category/category_section.dart";
import "package:mony_app/features/import/use_case/use_case.dart";
import "package:mony_app/i18n/strings.g.dart";

class ImportMapCategoriesPage extends StatelessWidget {
  final ImportEvent? event;

  const ImportMapCategoriesPage({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<ImportViewModel>();
    final categoryModel = viewModel.currentStep;
    if (categoryModel is! ImportModelCategory) {
      throw ArgumentError.value(categoryModel);
    }
    final count = categoryModel.mappedCategories.value.entries.fold<int>(
      0,
      (prev, curr) => prev + curr.value.length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -> title
              Text(
                context.t.features.import.map_categories.title,
                style: GoogleFonts.golosText(
                  fontSize: 20.0,
                  color: ColorScheme.of(context).onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15.0),

              // -> description
              Text(
                context.t.features.import.map_categories.description(n: count),
                style: GoogleFonts.golosText(
                  fontSize: 15.0,
                  height: 1.3,
                  color: ColorScheme.of(context).onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40.0),

        // -> categories
        ValueListenableBuilder(
          valueListenable: categoryModel.mappedCategories,
          builder: (context, categories, child) {
            final filtered = categories.entries.where(
              (e) => e.value.isNotEmpty,
            );

            return SeparatedComponent.builder(
              itemCount: filtered.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 40.0);
              },
              itemBuilder: (context, index) {
                final MapEntry(:key, :value) = filtered.elementAt(index);

                return ImportCategorySectionComponent(
                  transactionType: key.transactionType,
                  categories:
                      value..sort((a, b) {
                        return a.originalTitle.toLowerCase().compareTo(
                          b.originalTitle.toLowerCase(),
                        );
                      }),
                  onTap: viewModel<OnCategoryButtonPressed>(),
                  onReset: viewModel<OnCategoryResetPressed>(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
