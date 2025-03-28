import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:mony_app/features/search/use_case/use_case.dart";

class SearchTabPageComponent extends StatelessWidget {
  const SearchTabPageComponent({super.key});

  String get _keyPrefixTransaction => "search_transactions";
  String get _keyPrefixAccount => "search_accounts";
  String get _keyPrefixCategory => "search_categories";
  String get _keyPrefixTag => "search_tags";

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<SearchViewModel>();

    // -> empty state
    if (viewModel.isActiveTabEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateComponent(color: ColorScheme.of(context).onSurface),
      );
    }

    return switch (viewModel.activeTab) {
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
            onTap: viewModel<OnTransactionWithContextMenuPressed>(),
            onMenuSelected: viewModel<OnTransactionWithContextMenuSelected>(),
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
            accountCount: viewModel.accounts.length,
            balance: balance,
            isCentsVisible: viewModel.isCentsVisible,
            isColorsVisible: viewModel.isColorsVisible,
            onTap: viewModel<OnAccountPressed>(),
            onMenuSelected: viewModel<OnAccountWithContextMenuSelected>(),
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
            onTap: viewModel<OnCategoryPressed>(),
            onMenuSelected: viewModel<OnCategoryWithContextMenuSelected>(),
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
          return const SizedBox(height: 5.0);
        },
        itemCount: viewModel.tags.length,
        itemBuilder: (context, index) {
          final item = viewModel.tags.elementAt(index);

          return TagWithContextMenuComponent(
            key: ValueKey<String>("${_keyPrefixTag}_${item.id}"),
            tag: item,
            onTap: viewModel<OnTagPressed>(),
            onMenuSelected: viewModel<OnTagWithContextMenuSelected>(),
          );
        },
      ),
    };
  }
}
