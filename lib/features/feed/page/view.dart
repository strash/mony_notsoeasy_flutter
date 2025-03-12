import "package:flutter/material.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/features/feed/use_case/use_case.dart";

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  ValueKey<String> _pageKey(FeedPageState page) {
    return ValueKey<String>(switch (page) {
      FeedPageStateAllAccounts() => page.accounts.map((e) => e.id).join(),
      FeedPageStateSingleAccount() => page.account.id,
    });
  }

  Color _emptyStateColor(BuildContext context, FeedPageState page) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();

    return switch (page) {
      FeedPageStateAllAccounts() => theme.colorScheme.onSurface,
      FeedPageStateSingleAccount(:final account) =>
        (ex?.from(account.colorName).color ?? theme.colorScheme.onSurface),
    };
  }

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.paddingOf(context);

    final viewModel = context.viewModel<FeedViewModel>();
    final pages = viewModel.pages;
    final onMenuAddPressed = viewModel<OnMenuAddPressed>();
    final onAccountPressed = viewModel<OnAccountPressed>();
    final onPageChanged = viewModel<OnPageChanged>();
    final onTransactionPressed = viewModel<OnTransactionPressed>();
    final onTransactionMenuSelected =
        viewModel<OnTransactionContextMenuSelected>();

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
              final keyPrefix = "feed_page_$pageIndex";

              return CustomScrollView(
                key: _pageKey(page),
                controller: scrollControllers.elementAt(pageIndex).controller,
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

                  // -> feed
                  TransactionListComponent(
                    transactions: page.feed,
                    keyPrefix: keyPrefix,
                    isCentsVisible: viewModel.isCentsVisible,
                    isColorsVisible: viewModel.isColorsVisible,
                    isTagsVisible: viewModel.isTagsVisible,
                    showFullDate: false,
                    emptyStateColor: _emptyStateColor(context, page),
                    onTransactionPressed: onTransactionPressed,
                    onTransactionMenuSelected: onTransactionMenuSelected,
                  ),
                ],
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
