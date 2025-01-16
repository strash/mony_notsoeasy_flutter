import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account/component.dart";
import "package:mony_app/domain/models/account_balance.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:mony_app/features/feed/feed.dart";

class FeedAccountComponent extends StatelessWidget {
  final FeedPageState page;
  final bool showDecimal;
  final UseCase<void, FeedPageState> onTap;

  const FeedAccountComponent({
    super.key,
    required this.page,
    required this.showDecimal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(context, page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // -> sums
          switch (page) {
            final FeedPageStateAllAccounts page => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: page.balances.foldByCurrency().map(
                  (e) {
                    return FeedAccountAmountComponent(
                      amount: e.totalSum.currency(
                        name: e.currency.name,
                        symbol: e.currency.symbol,
                        showDecimal: showDecimal,
                      ),
                      code: e.currency.code,
                    );
                  },
                ).toList(growable: false),
              ),
            final FeedPageStateSingleAccount page => FeedAccountAmountComponent(
                amount: page.balance.totalSum.currency(
                  name: page.balance.currency.name,
                  symbol: page.balance.currency.symbol,
                  showDecimal: showDecimal,
                ),
                code: page.balance.currency.code,
              ),
          },
          const SizedBox(height: 10.0),

          // -> account
          switch (page) {
            FeedPageStateAllAccounts() => Text(
                "Все счета",
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.golosText(
                  fontSize: 18.0,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            FeedPageStateSingleAccount(:final account) =>
              AccountComponent(account: account),
          },

          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
