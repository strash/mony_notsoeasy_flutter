import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/search/components/components.dart";
import "package:mony_app/features/search/page/view_model.dart";

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<SearchViewModel>();
    final anim = viewModel.animation;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0x00FFFFFF),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // -> background
          ColoredBox(
            color: theme.colorScheme.surface.withValues(
              alpha: anim.value,
            ),
          ),

          Opacity(
            opacity: anim.value,
            child: CustomScrollView(
              slivers: [
                // -> appbar
                const SearchHeaderComponent(),

                // -> content
                SliverToBoxAdapter(
                  child: Center(child: Text("Search")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
