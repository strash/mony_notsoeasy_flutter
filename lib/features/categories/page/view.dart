import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/category/component.dart";
import "package:mony_app/features/categories/categories.dart";
import "package:mony_app/features/categories/components/add_button.dart";
import "package:mony_app/features/categories/use_case/use_case.dart";
import "package:mony_app/features/navbar/page/view.dart";

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<CategoriesViewModel>();
    final onAddButtonPressed = viewModel<OnMenuAddPressed>();
    final onCategoryPressed = viewModel<OnCategoryPressed>();

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
            trailing: Row(
              children: [
                CategoriesAddButtonComponent(
                  onTap: onAddButtonPressed,
                ),
                const SizedBox(width: 8.0),
              ],
            ),
          ),

          // -> categories
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 25.0);
              },
              itemCount: viewModel.categories.length,
              itemBuilder: (context, index) {
                final item = viewModel.categories.elementAt(index);

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onCategoryPressed(context, item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CategoryComponent(category: item),
                  ),
                );
              },
            ),
          ),

          // -> bottom offset
          SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
