import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/feed_item/component.dart";
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
    final viewModel = context.viewModel<SearchViewModel>();
    final onTransactionPressed = viewModel<OnTransactionPressed>();

    return CustomScrollView(
      controller: viewModel.getPageTabController(tab),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // -> top offset
        SliverToBoxAdapter(child: SizedBox(height: topOffset)),

        // -> content
        ...switch (tab) {
          ESearchTab.top => [SliverToBoxAdapter(child: Text(tab.description))],
          ESearchTab.transactions => viewModel.transactions.map((e) {
              return SliverToBoxAdapter(
                child: FeedItemComponent(
                  transaction: e,
                  onTap: onTransactionPressed,
                ),
              );
            }),
          ESearchTab.accounts => [
              SliverToBoxAdapter(child: Text(tab.description))
            ],
          ESearchTab.categories => [
              SliverToBoxAdapter(child: Text(tab.description))
            ],
          ESearchTab.tags => [SliverToBoxAdapter(child: Text(tab.description))],
        },

        // -> bottom offset
        SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
      ],
    );
  }
}
