import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/category_with_context_menu/component.dart";
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

  String get _keyPrefixTransaction => "search_transactions";
  String get _keyPrefixAccount => "search_accounts";
  String get _keyPrefixCategory => "search_categories";
  String get _keyPrefixTag => "search_tags";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<SearchViewModel>();
    final onTransactionPressed =
        viewModel<OnTransactionWithContextMenuPressed>();
    final onTransactionMenuSelected =
        viewModel<OnTransactionWithContextMenuSelected>();
    final onAccountPressed = viewModel<OnAccountPressed>();
    final onAccountMenuSelected = viewModel<OnAccountWithContextMenuSelected>();
    final onCategoryPressed = viewModel<OnCategoryPressed>();
    final onCategoryMenuSelected =
        viewModel<OnCategoryWithContextMenuSelected>();
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
              child: EmptyStateComponent(color: theme.colorScheme.onSurface),
            ),
          )
        // -> content
        else
          switch (tab) {
            // -> transactions
            ESearchTab.transactions => SliverList.separated(
              findChildIndexCallback: (key) {
                final id = (key as ValueKey).value;
                final index = viewModel.transactions.indexWhere((e) {
                  return "${_keyPrefixTransaction}_${e.id}" == id;
                });
                return index != -1 ? index : null;
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 5.0);
              },
              itemCount: viewModel.transactions.length,
              itemBuilder: (context, index) {
                final item = viewModel.transactions.elementAt(index);

                return TransactionWithContextMenuComponent(
                  key: ValueKey<String>("${_keyPrefixTransaction}_${item.id}"),
                  transaction: item,
                  isCentsVisible: viewModel.isCentsVisible,
                  isColorsVisible: viewModel.isColorsVisible,
                  isTagsVisible: viewModel.isTagsVisible,
                  showFullDate: true,
                  onTap: onTransactionPressed,
                  onMenuSelected: onTransactionMenuSelected,
                );
              },
            ),

            // -> accounts
            ESearchTab.accounts => SliverList.separated(
              findChildIndexCallback: (key) {
                final id = (key as ValueKey).value;
                final index = viewModel.accounts.indexWhere((e) {
                  return "${_keyPrefixAccount}_${e.id}" == id;
                });
                return index != -1 ? index : null;
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 5.0);
              },
              itemCount: viewModel.accounts.length,
              itemBuilder: (context, index) {
                final item = viewModel.accounts.elementAt(index);
                final balance = viewModel.balances.elementAtOrNull(index);

                return AccountWithContextMenuComponent(
                  key: ValueKey<String>("${_keyPrefixAccount}_${item.id}"),
                  account: item,
                  balance: balance,
                  isCentsVisible: viewModel.isCentsVisible,
                  isColorsVisible: viewModel.isColorsVisible,
                  onTap: onAccountPressed,
                  onMenuSelected: onAccountMenuSelected,
                );
              },
            ),

            // -> categories
            ESearchTab.categories => SliverList.separated(
              findChildIndexCallback: (key) {
                final id = (key as ValueKey).value;
                final index = viewModel.categories.indexWhere((e) {
                  return "${_keyPrefixCategory}_${e.id}" == id;
                });
                return index != -1 ? index : null;
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 5.0);
              },
              itemCount: viewModel.categories.length,
              itemBuilder: (context, index) {
                final item = viewModel.categories.elementAt(index);

                return CategoryWithContextMenuComponent(
                  key: ValueKey<String>("${_keyPrefixCategory}_${item.id}"),
                  category: item,
                  isColorsVisible: viewModel.isColorsVisible,
                  onTap: onCategoryPressed,
                  onMenuSelected: onCategoryMenuSelected,
                );
              },
            ),

            // -> tags
            ESearchTab.tags => SliverList.separated(
              findChildIndexCallback: (key) {
                final id = (key as ValueKey).value;
                final index = viewModel.tags.indexWhere((e) {
                  return "${_keyPrefixTag}_${e.id}" == id;
                });
                return index != -1 ? index : null;
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 25.0);
              },
              itemCount: viewModel.tags.length,
              itemBuilder: (context, index) {
                final item = viewModel.tags.elementAt(index);

                return GestureDetector(
                  key: ValueKey<String>("${_keyPrefixTag}_${item.id}"),
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
