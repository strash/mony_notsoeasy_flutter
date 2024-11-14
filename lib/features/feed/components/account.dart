import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/account_balance.dart";
import "package:mony_app/features/feed/page/page.dart";

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
    final ex = theme.extension<ColorExtension>();
    return switch (page) {
      FeedPageStateAllAccounts() => theme.colorScheme.primary,
      final FeedPageStateSingleAccount page =>
        ex?.from(page.account.colorName).color ?? theme.colorScheme.primary,
    };
  }

  TextStyle _getStyle(BuildContext context) {
    final theme = Theme.of(context);
    return GoogleFonts.golosText(
      fontSize: 40.sp,
      height: 1.1,
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // -> sums
        FittedBox(
          child: switch (page) {
            final FeedPageStateAllAccounts page => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: page.balances.foldByCurrency().map(
                  (e) {
                    return Text(
                      e.totalSum.currency(
                        name: e.currency.name,
                        symbol: e.currency.symbol,
                      ),
                      style: _getStyle(context),
                    );
                  },
                ).toList(growable: false),
              ),
            final FeedPageStateSingleAccount page => Text(
                page.balance.totalSum.currency(
                  name: page.balance.currency.name,
                  symbol: page.balance.currency.symbol,
                ),
                style: _getStyle(context),
              ),
          },
        ),
        SizedBox(height: 10.h),

        // -> title
        Flexible(
          child: Text(
            _title,
            textAlign: TextAlign.center,
            style: GoogleFonts.golosText(
              fontSize: 18.sp,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: _getColor(context),
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
        SizedBox(height: 20.h),
      ],
    );
  }
}
