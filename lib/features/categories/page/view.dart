import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/category/component.dart";
import "package:mony_app/components/feed_empty_state/component.dart";
import "package:mony_app/features/categories/categories.dart";
import "package:mony_app/features/categories/components/add_button.dart";
import "package:mony_app/features/categories/use_case/use_case.dart";
import "package:mony_app/features/navbar/page/view.dart";

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<CategoriesViewModel>();
    final onAddButtonPressed = viewModel<OnMenuAddPressed>();
    final onCategoryPressed = viewModel<OnCategoryPressed>();
    final isEmpty = viewModel.categories.isEmpty;

    return Scaffold(
      body: CustomScrollView(
        controller: viewModel.controller,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> app bar
          AppBarComponent(
            title: const Text("Категории"),
            trailing: CategoriesAddButtonComponent(
              onTap: onAddButtonPressed,
            ),
          ),

          // -> empty state
          if (isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomOffset),
                child: FeedEmptyStateComponent(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            )

          // -> categories
          else
            SliverPadding(
              padding: const EdgeInsets.only(top: 20.0),
              sliver: SliverList.separated(
                findChildIndexCallback: (key) {
                  final id = (key as ValueKey).value;
                  final index =
                      viewModel.categories.indexWhere((e) => e.id == id);
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
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onCategoryPressed(context, item),
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
            ),

          // -> bottom offset
          if (!isEmpty)
            SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
