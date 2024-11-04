import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/feed/page/page.dart";
import "package:sealed_currencies/sealed_currencies.dart";

class FeedAccountComponent extends StatelessWidget {
  final FeedPageState page;

  const FeedAccountComponent({
    super.key,
    required this.page,
  });

  String get _title {
    return switch (page) {
      FeedPageStateAllAccounts() => "Все счета",
      final FeedPageStateSingleAccount page => page.account.title,
    };
  }

  Color _getColor(BuildContext context) {
    final theme = Theme.of(context);
    return switch (page) {
      FeedPageStateAllAccounts() => theme.colorScheme.primary,
      final FeedPageStateSingleAccount page => page.account.color,
    };
  }

  TextStyle _getStyle(BuildContext context) {
    final theme = Theme.of(context);
    return GoogleFonts.golosText(
      fontSize: 40.sp,
      color: theme.colorScheme.onSurface,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // -> top row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -> color
            if (page is FeedPageStateSingleAccount)
              Padding(
                padding: EdgeInsets.only(top: 6.h, right: 6.w),
                child: SizedBox.square(
                  dimension: 10.r,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: _getColor(context),
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              ),

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -> title
                Flexible(
                  child: Text(
                    _title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.golosText(
                      fontSize: 16.sp,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),

                // -> account type
                switch (page) {
                  FeedPageStateAllAccounts() => const SizedBox(),
                  final FeedPageStateSingleAccount page => Text(
                      page.account.type.description,
                      style: GoogleFonts.golosText(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                },
              ],
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // -> sums
        FittedBox(
          child: switch (page) {
            final FeedPageStateAllAccounts page => Column(
                children: page.balances.map((e) {
                  return Text(
                    e.currency.format(e.totalSum.roundToFraction(2)),
                    style: _getStyle(context),
                  );
                }).toList(growable: false),
              ),
            final FeedPageStateSingleAccount page => Text(
                page.balance.currency
                    .format(page.balance.totalSum.roundToFraction(2)),
                style: _getStyle(context),
              ),
          },
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
