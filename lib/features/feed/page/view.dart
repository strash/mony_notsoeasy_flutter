import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/features/navbar/page/view.dart";

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  ValueKey<String> _pageKey(FeedPageState page) {
    return ValueKey<String>(
      switch (page) {
        FeedPageStateAllAccounts() => page.accounts.map((e) => e.id).join(),
        FeedPageStateSingleAccount() => page.account.id,
      },
    );
  }

  ValueKey<String> _feedItemKey(FeedItem feedItem) {
    return ValueKey<String>(
      switch (feedItem) {
        FeedItemSection() => feedItem.date.toString(),
        FeedItemTransaction() => feedItem.transaction.id,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.paddingOf(context);
    final bottomOffset = NavbarView.bottomOffset(context);

    final viewModel = context.viewModel<FeedViewModel>();
    final pages = viewModel.pages;
    final onAddAccountPressed = viewModel<OnAddAccountPressed>();
    final onAccountPressed = viewModel<OnAccountPressed>();
    final onPageChanged = viewModel<OnPageChanged>();
    final scrollControllers = viewModel.scrollControllers;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            restorationId: "feed_pages",
            controller: viewModel.pageController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(
                parent: PageScrollPhysics(),
              ),
            ),
            onPageChanged: (index) => onPageChanged(context, index),
            findChildIndexCallback: (key) {
              final id = (key as ValueKey<String>).value;
              final idx = pages.indexWhere((e) => id == _pageKey(e).value);
              return idx != -1 ? idx : null;
            },
            itemCount: pages.length,
            itemBuilder: (context, pageIndex) {
              final page = pages.elementAt(pageIndex);
              final feed = page.feed.toFeed();

              return CustomScrollView(
                key: _pageKey(page),
                controller: scrollControllers.elementAt(pageIndex),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  // -> account
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      top: viewPadding.top + 60.h,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: FeedAccountComponent(
                        page: page,
                        onTap: onAccountPressed,
                      ),
                    ),
                  ),

                  // -> empty state
                  if (page.feed.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: NavbarView.kTabHeight +
                              NavbarView.kBottomMargin * 2.0 +
                              20.h,
                        ),
                        child: const FeedEmptyStateComponent(),
                      ),
                    )

                  // -> feed
                  else
                    SliverPadding(
                      padding: EdgeInsets.only(bottom: bottomOffset),
                      sliver: SliverList.builder(
                        itemCount: feed.length,
                        findChildIndexCallback: (key) {
                          final id = (key as ValueKey<String>).value;
                          final index = feed.indexWhere((e) {
                            return id == _feedItemKey(e).value;
                          });
                          return index != -1 ? index : null;
                        },
                        itemBuilder: (context, index) {
                          final item = feed.elementAt(index);
                          final key = _feedItemKey(item);

                          return switch (item) {
                            FeedItemSection() => FeedSectionComponent(
                                key: key,
                                section: item,
                              ),
                            FeedItemTransaction() => FeedItemComponent(
                                key: key,
                                transaction: item.transaction,
                              )
                          };
                        },
                      ),
                    ),
                ],
              );
            },
          ),

          // -> pager
          const FeedPagerComponent(),

          // -> button add account
          FeedAddAccountComponent(
            onTap: () => onAddAccountPressed(context),
          ),
        ],
      ),
    );
  }
}
