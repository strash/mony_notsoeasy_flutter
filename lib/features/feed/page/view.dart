import "package:flutter/material.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/features/feed/use_case/use_case.dart";
import "package:mony_app/features/navbar/page/view.dart";

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  ValueKey<String> _pageKey(FeedPageState page) {
    return ValueKey<String>(switch (page) {
      FeedPageStateAllAccounts() => page.accounts.map((e) => e.id).join(),
      FeedPageStateSingleAccount() => page.account.id,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final viewPadding = MediaQuery.paddingOf(context);
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<FeedViewModel>();
    final pages = viewModel.pages;
    final onTransactionPressed = viewModel<OnTransactionPressed>();
    final onMenuAddPressed = viewModel<OnMenuAddPressed>();
    final onAccountPressed = viewModel<OnAccountPressed>();
    final onPageChanged = viewModel<OnPageChanged>();
    final scrollControllers = viewModel.scrollControllers;
    final pageController = viewModel.pageController;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            restorationId: "feed_pages",
            controller: pageController,
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
              final keyPrefix = "feed_page_$pageIndex";

              return AnimatedBuilder(
                key: _pageKey(page),
                animation: pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (pageController.position.haveDimensions &&
                      pageController.page != null) {
                    value = pageController.page! - pageIndex;
                    value = (1.0 - value.abs()).clamp(0.0, 1.0);
                  }
                  final controller =
                      scrollControllers.elementAt(pageIndex).controller;

                  return Opacity(
                    opacity: value,
                    child: CustomScrollView(
                      controller: controller,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        // -> account
                        SliverPadding(
                          padding: EdgeInsets.only(
                            left: 7.0,
                            right: 7.0,
                            top: viewPadding.top + 60.0,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: FeedAccountComponent(
                              page: page,
                              onTap: onAccountPressed,
                              showDecimal: viewModel.isCentsVisible,
                              showColors: viewModel.isColorsVisible,
                            ),
                          ),
                        ),

                        // -> empty state
                        if (page.feed.isEmpty)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: NavBarView.bottomOffset(context),
                              ),
                              child: switch (page) {
                                FeedPageStateAllAccounts() =>
                                  FeedEmptyStateComponent(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                FeedPageStateSingleAccount(:final account) =>
                                  FeedEmptyStateComponent(
                                    color:
                                        viewModel.isColorsVisible
                                            ? (ex
                                                    ?.from(account.colorName)
                                                    .color ??
                                                theme.colorScheme.onSurface)
                                            : theme.colorScheme.onSurface,
                                  ),
                              },
                            ),
                          )
                        // -> feed
                        else
                          SliverPadding(
                            padding: EdgeInsets.only(bottom: bottomOffset),
                            sliver: SliverList.separated(
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 25.0);
                              },
                              itemCount: feed.length,
                              findChildIndexCallback: (key) {
                                final id = (key as ValueKey<String>).value;
                                final index = feed.indexWhere((e) {
                                  return id == feed.key(e, keyPrefix).value;
                                });
                                return index != -1 ? index : null;
                              },
                              itemBuilder: (context, index) {
                                final item = feed.elementAt(index);
                                final key = feed.key(item, keyPrefix);

                                return switch (item) {
                                  FeedItemSection() => Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      20.0,
                                      30.0,
                                      20.0,
                                      .0,
                                    ),
                                    child: FeedSectionComponent(
                                      key: key,
                                      section: item,
                                      showDecimal: viewModel.isCentsVisible,
                                    ),
                                  ),
                                  FeedItemTransaction() => GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap:
                                        () => onTransactionPressed(
                                          context,
                                          item.transaction,
                                        ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: FeedItemComponent(
                                        key: key,
                                        transaction: item.transaction,
                                        showDecimal: viewModel.isCentsVisible,
                                        showColors: viewModel.isColorsVisible,
                                        showTags: viewModel.isTagsVisible,
                                      ),
                                    ),
                                  ),
                                };
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          // -> pager
          const FeedPagerComponent(),

          // -> button add account/category/tag
          FeedAddButtonComponent(onTap: onMenuAddPressed),
        ],
      ),
    );
  }
}
