import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account/component.dart";
import "package:mony_app/domain/models/account_balance.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:mony_app/features/feed/feed.dart";
import "package:mony_app/gen/assets.gen.dart";

class FeedAccountComponent extends StatelessWidget {
  final FeedPageState page;
  final bool showDecimal;
  final bool showColors;
  final UseCase<void, FeedPageState> onTap;

  const FeedAccountComponent({
    super.key,
    required this.page,
    required this.showDecimal,
    required this.showColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();

    final locale = Localizations.localeOf(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(context, page),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: .8),
            shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.all(
                SmoothRadius(cornerRadius: 30.0, cornerSmoothing: .6),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // -> sums
                switch (page) {
                  final FeedPageStateAllAccounts page => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: page.balances
                        .foldByCurrency()
                        .map((e) {
                          return FeedAccountAmountComponent(
                            amount: e.totalSum.currency(
                              locale: locale.languageCode,
                              name: e.currency.name,
                              symbol: e.currency.symbol,
                              showDecimal: showDecimal,
                            ),
                            code: e.currency.code,
                            showColors: showColors,
                          );
                        })
                        .toList(growable: false),
                  ),
                  final FeedPageStateSingleAccount page =>
                    FeedAccountAmountComponent(
                      amount: page.balance.totalSum.currency(
                        locale: locale.languageCode,
                        name: page.balance.currency.name,
                        symbol: page.balance.currency.symbol,
                        showDecimal: showDecimal,
                      ),
                      code: page.balance.currency.code,
                      color: ex?.from(page.account.colorName).color,
                      showColors: showColors,
                    ),
                },
                const SizedBox(height: 10.0),

                // -> account
                switch (page) {
                  FeedPageStateAllAccounts() => Row(
                    children: [
                      SvgPicture.asset(
                        Assets.icons.widgetSmall,
                        width: 26.0,
                        height: 26.0,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.tertiary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Flexible(
                        child: Text(
                          "Все счета",
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.golosText(
                            fontSize: 16.0,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FeedPageStateSingleAccount(:final account) =>
                    AccountComponent(account: account, showColors: showColors),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}
