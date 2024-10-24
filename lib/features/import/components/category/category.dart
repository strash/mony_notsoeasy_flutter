import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/import/page/view_model.dart";

class ImporteCategoryItemComponent extends StatelessWidget {
  final ETransactionType transactionType;
  final List<TMappedCategory> categories;

  const ImporteCategoryItemComponent({
    super.key,
    required this.transactionType,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Категории доходов",
          style: GoogleFonts.golosText(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.tertiary,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: categories.map((e) {
            return Text(
              e.title,
              style: GoogleFonts.golosText(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.tertiary,
              ),
            );
          }).toList(growable: false),
        ),
      ],
    );
  }
}
