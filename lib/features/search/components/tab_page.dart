import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:mony_app/features/search/use_case/use_case.dart";

class SearchTabPageComponent extends StatelessWidget {
  final ESearchTab tab;
  final double topOffset;
  final double bottomOffset;

  const SearchTabPageComponent({
    super.key,
    required this.tab,
    required this.topOffset,
    required this.bottomOffset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<SearchViewModel>();
    final onTransactionPressed = viewModel<OnTransactionPressed>();
    final onAccountPressed = viewModel<OnAccountPressed>();
    final onCategoryPressed = viewModel<OnCategoryPressed>();
    final onTagPressed = viewModel<OnTagPressed>();
    final isEmpty = switch (tab) {
      ESearchTab.transactions => viewModel.transactions.isEmpty,
      ESearchTab.accounts => viewModel.accounts.isEmpty,
      ESearchTab.categories => viewModel.categories.isEmpty,
      ESearchTab.tags => viewModel.tags.isEmpty,
    };

    return CustomScrollView(
      controller: viewModel.getPageTabController(tab),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // -> top offset
        SliverToBoxAdapter(child: SizedBox(height: topOffset)),

        // -> empty state
        if (isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: topOffset),
              child: FeedEmptyStateComponent(
                color: theme.colorScheme.onSurface,
              ),
            ),
          )
        // -> content
        else
          switch (tab) {
            // -> transactions
            ESearchTab.transactions => SliverList.separated(
              findChildIndexCallback: (key) {
                final id = (key as ValueKey).value;
                final index = viewModel.transactions.indexWhere(
                  (e) => e.id == id,
                );
                return index != -1 ? index : null;
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 25.0);
              },
              itemCount: viewModel.transactions.length,
              itemBuilder: (context, index) {
                final item = viewModel.transactions.elementAt(index);

                return GestureDetector(
                  key: ValueKey<String>(item.id),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTransactionPressed(context, item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FeedItemComponent(
                      transaction: item,
                      showFullDate: true,
                      showDecimal: viewModel.isCentsVisible,
                      showColors: viewModel.isColorsVisible,
                      showTags: viewModel.isTagsVisible,
                    ),
                  ),
                );
              },
            ),

            // -> accounts
            ESearchTab.accounts => SliverList.separated(
              findChildIndexCallback: (key) {
                final id = (key as ValueKey).value;
                final index = viewModel.accounts.indexWhere((e) => e.id == id);
                return index != -1 ? index : null;
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 25.0);
              },
              itemCount: viewModel.accounts.length,
              itemBuilder: (context, index) {
                final item = viewModel.accounts.elementAt(index);
                final balance = viewModel.balances.elementAtOrNull(index);

                return GestureDetector(
                  key: ValueKey<String>(item.id),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onAccountPressed.call(context, item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: AccountComponent(
                      account: item,
                      balance: balance,
                      showCurrencyTag: true,
                      showColors: viewModel.isColorsVisible,
                      showCents: viewModel.isCentsVisible,
                    ),
                  ),
                );
              },
            ),

            // -> categories
            ESearchTab.categories => SliverList.separated(
              findChildIndexCallback: (key) {
                final id = (key as ValueKey).value;
                final index = viewModel.categories.indexWhere(
                  (e) => e.id == id,
                );
                return index != -1 ? index : null;
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 25.0);
              },
              itemCount: viewModel.categories.length,
              itemBuilder: (context, index) {
                final item = viewModel.categories.elementAt(index);

                return GestureDetector(
                  key: ValueKey<String>(item.id),
                  onTap: () => onCategoryPressed.call(context, item),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CategoryComponent(
                      category: item,
                      showColors: viewModel.isColorsVisible,
                    ),
                  ),
                );
              },
            ),

            // -> tags
            ESearchTab.tags => SliverList.separated(
              findChildIndexCallback: (key) {
                final id = (key as ValueKey).value;
                final index = viewModel.tags.indexWhere((e) => e.id == id);
                return index != -1 ? index : null;
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 25.0);
              },
              itemCount: viewModel.tags.length,
              itemBuilder: (context, index) {
                final item = viewModel.tags.elementAt(index);

                return GestureDetector(
                  key: ValueKey<String>(item.id),
                  onTap: () => onTagPressed.call(context, item),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [Flexible(child: TagComponent(tag: item))],
                    ),
                  ),
                );
              },
            ),
          },

        // -> bottom offset
        if (!isEmpty) SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
      ],
    );
  }
}
