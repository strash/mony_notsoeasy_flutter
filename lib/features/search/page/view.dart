import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/search/components/components.dart";
import "package:mony_app/features/search/page/view_model.dart";

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomOffset = MediaQuery.paddingOf(context).bottom + 50.0;

    final viewModel = context.viewModel<SearchViewModel>();
    final isEmpty = switch (viewModel.activeTab) {
      ESearchTab.transactions => viewModel.transactions.isEmpty,
      ESearchTab.accounts => viewModel.accounts.isEmpty,
      ESearchTab.categories => viewModel.categories.isEmpty,
      ESearchTab.tags => viewModel.tags.isEmpty,
    };

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: ColorScheme.of(context).surface,
      body: CustomScrollView(
        controller: viewModel.getPageTabController(viewModel.activeTab),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> appbar
          const SearchAppBarComponent(),

          const SliverToBoxAdapter(child: SizedBox(height: 20.0)),

          switch (viewModel.isSearching) {
            // -> page buttons
            false => SliverList.builder(
              itemCount: ESearchPage.values.length,
              itemBuilder: (context, index) {
                final item = ESearchPage.values.elementAt(index);
                return SearchPageButtonComponent(page: item);
              },
            ),

            // -> search tab pages
            true => const SearchTabPageComponent(),
          },

          // -> bottom offset
          if (!isEmpty)
            SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
