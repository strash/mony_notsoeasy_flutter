import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
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
      fontSize: 30.sp,
      color: theme.colorScheme.onSurface,
      fontWeight: FontWeight.w500,
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
          children: [
            // -> color
            Padding(
              padding: EdgeInsets.only(top: 2.h),
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
            SizedBox(width: 6.w),

            // -> title
            Flexible(
              child: Text(
                _title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.golosText(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
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
        SizedBox(height: 10.h),

        // -> sums
        switch (page) {
          final FeedPageStateAllAccounts page => Column(
              children: page.accounts.map((e) {
                return Text(
                  e.currency.format(e.balance.roundToFraction(2)),
                  style: _getStyle(context),
                );
              }).toList(growable: false),
            ),
          final FeedPageStateSingleAccount page => Text(
              page.account.currency
                  .format(page.account.balance.roundToFraction(2)),
              style: _getStyle(context),
            ),
        },
        SizedBox(height: 10.h),
      ],
    );
  }
}
