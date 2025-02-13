import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/components/category/category_section.dart";
import "package:mony_app/features/import/use_case/use_case.dart";

class ImportMapCategoriesPage extends StatelessWidget {
  final ImportEvent? event;

  const ImportMapCategoriesPage({super.key, this.event});

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

    final locale = Localizations.localeOf(context);

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
                "Категории",
                style: GoogleFonts.golosText(
                  fontSize: 20.0,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15.0),

              // -> description
              Text(
                "Я нашел "
                // ignore: lines_longer_than_80_chars
                "${categoryModel.numberOfCategoriesDescription(locale.languageCode)}. "
                "Их нужно привязать к предустановленным категориям, "
                "либо дополнить информацией.",
                style: GoogleFonts.golosText(
                  fontSize: 15.0,
                  height: 1.3,
                  color: theme.colorScheme.onSurfaceVariant,
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
