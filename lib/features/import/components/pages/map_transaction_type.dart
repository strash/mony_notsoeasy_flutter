import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/components/components.dart";

class ImportMapTransactionTypePage extends StatelessWidget {
  final ImportEvent? event;

  const ImportMapTransactionTypePage({
    super.key,
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<ImportViewModel>();
    final transactionsByType = viewModel.transactionsByType;

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
                "Типы транзакций",
                style: GoogleFonts.golosText(
                  fontSize: 20.sp,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15.h),

              // -> description
              Text(
                "Являются ли транзакции в этой таблице расходами?",
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

        // -> table
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: TypesTableComponent(transactionsByType: transactionsByType),
        ),
        SizedBox(height: 30.h),

        // -> select
        Center(
          child: TabGroupComponent(
            values: ETypeDecision.values,
            controller: viewModel.transactionTypeDecisionController,
          ),
        ),
      ],
    );
  }
}
