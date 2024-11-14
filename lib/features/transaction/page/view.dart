import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/transaction/page/page.dart";

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final viewPadding = MediaQuery.paddingOf(context);

    final bottomOffset = viewPadding.bottom +
        NavbarView.kBottomMargin * 2.0 +
        NavbarView.kTabHeight +
        50.h;

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
        theme.colorScheme.onSurface;
    final accountColor = ex?.from(transaction.account.colorName).color ??
        theme.colorScheme.onSurface;

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // -> icon
                  SizedBox.square(
                    dimension: 100.r,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.lerp(
                              categoryColor,
                              const Color(0xFFFFFFFF),
                              .3,
                            )!,
                            categoryColor,
                          ],
                        ),
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
                  Flexible(
                    child: Text(
                      transaction.category.title,
                      style: GoogleFonts.golosText(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: categoryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 40.h)),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // -> amount
                  FittedBox(
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
                  SizedBox(height: 10.h),

                  // -> date
                  Text(
                    formattedDate,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.golosText(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),

          // -> account
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -> account
                  Flexible(
                    child: Text(
                      transaction.account.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.golosText(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: accountColor,
                      ),
                    ),
                  ),
                  Text(
                    transaction.account.type.description,
                    style: GoogleFonts.golosText(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),

          // -> tags
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 6.r,
                runSpacing: 6.r,
                children: transaction.tags.map((e) {
                  return DecoratedBox(
                    decoration: ShapeDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.all(
                          SmoothRadius(
                            cornerRadius: 12.r,
                            cornerSmoothing: 1.0,
                          ),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 10.h,
                      ),
                      child: Text(
                        e.title,
                        style: GoogleFonts.golosText(
                          fontSize: 15.sp,
                          height: 1.0,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(growable: false),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 30.h)),

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
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // -> bottom offset
          SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
