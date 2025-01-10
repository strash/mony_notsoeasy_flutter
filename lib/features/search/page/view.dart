import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/search/components/components.dart";
import "package:mony_app/features/search/page/view_model.dart";

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewPadding = MediaQuery.paddingOf(context);
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<SearchViewModel>();
    final topOffset = viewPadding.top +
        20.0 +
        (viewModel.isSearching
            ? SearchAppBarComponent.maximizedHeight
            : SearchAppBarComponent.collapsedHeight);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Durations.short3,
            child: viewModel.isSearching
                // -> search result tabs
                ? AnimatedSwitcher(
                    key: const Key("tabs"),
                    duration: Durations.short3,
                    child: SearchTabPageComponent(
                      key: Key("tab_${viewModel.activeTab.name}"),
                      tab: viewModel.activeTab,
                      topOffset: topOffset,
                      bottomOffset: bottomOffset,
                    ),
                  )

                // -> pages
                : CustomScrollView(
                    key: const Key("pages"),
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      // -> top offset
                      SliverToBoxAdapter(child: SizedBox(height: topOffset)),

                      // -> content
                      SliverList.builder(
                        itemCount: ESearchPage.values.length,
                        itemBuilder: (context, index) {
                          final item = ESearchPage.values.elementAt(index);

                          return SearchPageButtonComponent(page: item);
                        },
                      ),

                      // -> bottom offset
                      SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
                    ],
                  ),
          ),

          // -> appbar
          const Positioned(
            top: .0,
            left: .0,
            right: .0,
            child: SearchAppBarComponent(),
          ),
        ],
      ),
    );
  }
}
