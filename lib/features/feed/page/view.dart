import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/features/navbar/page/view.dart";

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.paddingOf(context);

    final bottomOffset = viewPadding.bottom +
        NavbarView.kBottomMargin * 2.0 +
        NavbarView.kTabHeight +
        50.h;

    final viewModel = context.viewModel<FeedViewModel>();
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
            physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
            onPageChanged: (index) {
              onPageChanged(context, index);
            },
            findChildIndexCallback: (key) {
              final id = (key as ValueKey<String>).value;
              return viewModel.pages.indexWhere((page) {
                return switch (page) {
                  FeedPageStateAllAccounts() =>
                    id == page.accounts.map((e) => e.id).join(),
                  FeedPageStateSingleAccount() => id == page.account.id,
                };
              });
            },
            itemCount: viewModel.pages.length,
            itemBuilder: (context, pageIndex) {
              final page = viewModel.pages.elementAt(pageIndex);
              final ValueKey<String> key;
              switch (page) {
                case FeedPageStateAllAccounts():
                  key = ValueKey(page.accounts.map((e) => e.id).join());
                case FeedPageStateSingleAccount():
                  key = ValueKey(page.account.id);
              }

              return CustomScrollView(
                key: key,
                controller: scrollControllers.elementAt(pageIndex),
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // -> account
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      top: viewPadding.top + 70.h,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: FeedAccountComponent(page: page),
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
                        itemCount: page.feed.length,
                        findChildIndexCallback: (key) {
                          final id = (key as ValueKey<String>).value;
                          return page.feed.indexWhere((e) {
                            return switch (e) {
                              FeedItemSection() => id == e.date.toString(),
                              FeedItemTransaction() => id == e.transaction.id,
                            };
                          });
                        },
                        itemBuilder: (context, index) {
                          final item = page.feed.elementAt(index);

                          switch (item) {
                            case FeedItemSection():
                              return FeedSectionComponent(
                                key: ValueKey<String>(item.date.toString()),
                                section: item,
                              );
                            case FeedItemTransaction():
                              return FeedItemComponent(
                                key: ValueKey<String>(item.transaction.id),
                                transaction: item.transaction,
                              );
                          }
                        },
                      ),
                    ),
                ],
              );
            },
          ),

          // -> pager
          const FeedPagerComponent(),
        ],
      ),
    );
  }
}
