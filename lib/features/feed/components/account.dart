import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/account_balance.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:mony_app/features/feed/page/page.dart";
import "package:mony_app/gen/assets.gen.dart";

class FeedAccountComponent extends StatelessWidget {
  final FeedPageState page;
  final UseCase<void, FeedPageState> onTap;

  const FeedAccountComponent({
    super.key,
    required this.page,
    required this.onTap,
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
                ),
                code: page.balance.currency.code,
              ),
          },
          // ignore: prefer_const_constructors
          SizedBox(height: 10.0),

          // -> title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  _title,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.golosText(
                    fontSize: 18.0,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: _getColor(context),
                  ),
                ),
              ),

              // -> icon
              Padding(
                padding: const EdgeInsets.only(left: 2.0, top: 1.0),
                child: SvgPicture.asset(
                  Assets.icons.chevronForward,
                  width: 20.0,
                  height: 20.0,
                  colorFilter: ColorFilter.mode(
                    _getColor(context),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),

          // -> account type
          switch (page) {
            FeedPageStateAllAccounts() => const SizedBox(),
            FeedPageStateSingleAccount(:final account) => Text(
                account.type.description,
                style: GoogleFonts.golosText(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          },
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
