import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/features/transaction/page/page.dart";

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();

    final viewModel = context.viewModel<TransactionViewModel>();
    final transaction = viewModel.transaction;
    final now = DateTime.now();
    final dateFormatter = DateFormat(
      now.year != transaction.date.year
          ? "EEE, dd MMMM yyyy, HH:mm"
          : "EEE, dd MMMM, HH:mm",
    );
    final formattedDate = dateFormatter.format(transaction.date);
    final categoryColor = ex?.from(transaction.category.colorName).color ??
        theme.colorScheme.surfaceContainer;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // -> appbar
          const AppBarComponent(showBackground: false),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),

          // -> category
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  // -> icon
                  SizedBox.square(
                    dimension: 100.r,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: categoryColor,
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius.all(
                            SmoothRadius(
                              cornerRadius: 30.r,
                              cornerSmoothing: 1.0,
                            ),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          transaction.category.icon,
                          style: theme.textTheme.displayLarge,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // -> title
                  Text(
                    transaction.category.title,
                    style: GoogleFonts.golosText(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: categoryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 30.h)),

          // -> amount
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Text(
                transaction.amount.currency(
                  name: transaction.account.currency.name,
                  symbol: transaction.account.currency.symbol,
                ),
                textAlign: TextAlign.center,
                style: GoogleFonts.golosText(
                  fontSize: 40.sp,
                  height: 1.1,
                  fontWeight: FontWeight.w600,
                  color: transaction.amount.isNegative
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.secondary,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),

          // -> date
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Text(
                formattedDate,
                textAlign: TextAlign.center,
                style: GoogleFonts.golosText(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 40.h)),

          // -> note
          if (transaction.note.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -> title
                    Text(
                      "Заметка",
                      style: GoogleFonts.golosText(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // -> the note
                    Text(
                      transaction.note,
                      style: GoogleFonts.golosText(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
