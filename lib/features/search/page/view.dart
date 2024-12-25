import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
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
    final pagesTopOffset =
        viewPadding.top + SearchAppBarComponent.collapsedHeight + 20.0;

    final viewModel = context.viewModel<SearchViewModel>();

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
                // -> search results
                ? CustomScrollView(
                    key: const Key("search_resulst"),
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(
                          top: viewPadding.top + AppBarComponent.height + 20.0,
                        ),
                        sliver: SliverToBoxAdapter(child: Text("yaya")),
                      ),

                      // -> bottom offset
                      SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
                    ],
                  )

                // -> pages
                : CustomScrollView(
                    key: const Key("pages"),
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      // -> top offset
                      SliverToBoxAdapter(
                          child: SizedBox(height: pagesTopOffset)),

                      // -> content
                      SliverList.builder(
                        itemCount: ESearchPage.values.length,
                        itemBuilder: (context, index) {
                          final item = ESearchPage.values.elementAt(index);

                          return SearchPageItemComponent(page: item);
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
