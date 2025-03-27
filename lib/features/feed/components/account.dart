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
import "package:mony_app/i18n/strings.g.dart";

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
    final ex = Theme.of(context).extension<ColorExtension>();

    final locale = Localizations.localeOf(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(context, page),
        child: LayoutBuilder(
          builder: (context, constrains) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // -> stack
                if (page is FeedPageStateAllAccounts)
                  Positioned(
                    left: 15.0,
                    bottom: -8.0,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: Color.lerp(
                          ColorScheme.of(context).surface,
                          ColorScheme.of(context).surfaceContainerHigh,
                          .5,
                        ),
                        shape: Smooth.border(20.0),
                      ),
                      child: SizedBox(
                        width: constrains.maxWidth - 30.0,
                        height: 50.0,
                      ),
                    ),
                  ),

                // -> card
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: ColorScheme.of(context).surfaceContainerHigh,
                    shape: Smooth.border(30.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      15.0,
                      13.0,
                      15.0,
                      page is FeedPageStateAllAccounts ? 10.0 : 15.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -> sums
                        switch (page) {
                          final FeedPageStateAllAccounts page => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: page.balances
                                .foldByCurrency(page.accounts)
                                .map((e) {
                                  return FeedAccountAmountComponent(
                                    amount: e.$1.totalSum.currency(
                                      locale: locale.languageCode,
                                      name: e.$1.currency.name,
                                      symbol: e.$1.currency.symbol,
                                      showDecimal: showDecimal,
                                    ),
                                    code: e.$1.currency.code,
                                    accountColors: e.$2
                                        .map((a) => ex?.from(a.colorName).color)
                                        .toList(growable: false),
                                    showColors: showColors,
                                    showCurrencyTag: true,
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
                              showColors: showColors,
                              showCurrencyTag: false,
                            ),
                        },
                        const SizedBox(height: 5.0),

                        // -> account
                        switch (page) {
                          FeedPageStateAllAccounts() => Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  Assets.icons.widgetSmall,
                                  width: 24.0,
                                  height: 24.0,
                                  colorFilter: ColorFilter.mode(
                                    ColorScheme.of(context).onSurfaceVariant,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 1.0),
                                  child: Text(
                                    context.t.features.feed.account.title_all,
                                    style: GoogleFonts.golosText(
                                      fontSize: 15.0,
                                      height: 1.0,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          ColorScheme.of(
                                            context,
                                          ).onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FeedPageStateSingleAccount(:final account) =>
                            AccountComponent(
                              account: account,
                              showColors: showColors,
                            ),
                        },
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
