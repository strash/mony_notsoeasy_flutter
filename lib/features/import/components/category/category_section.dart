import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class ImportCategorySectionComponent extends StatelessWidget {
  final ETransactionType transactionType;
  final List<ImportModelCategoryVariant> categories;
  final UseCase<Future<void>, ImportModelCategoryVariant> onTap;
  final UseCase<void, ImportModelCategoryVariant> onReset;

  const ImportCategorySectionComponent({
    super.key,
    required this.transactionType,
    required this.categories,
    required this.onTap,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final count = categories.fold<int>(0, (prev, e) {
      return prev + (e is ImportModelCategoryVariantEmpty ? 0 : 1);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // -> icon
              if (count == categories.length)
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: SvgPicture.asset(
                    Assets.icons.checkmarkCircleFill,
                    width: 20.0,
                    height: 20.0,
                    colorFilter: ColorFilter.mode(
                      ColorScheme.of(context).secondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),

              // -> title
              Text(
                context.t.features.import.map_categories.category_section_title(
                  context: transactionType,
                  count: count,
                  n: categories.length,
                ),
                style: GoogleFonts.golosText(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: ColorScheme.of(context).tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),

          // -> categories
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: categories
                .map((e) {
                  return ImportCategoryItemComponent(
                    category: e,
                    onTap: onTap,
                    onReset: onReset,
                  );
                })
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}
