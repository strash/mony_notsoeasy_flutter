import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/appbar_button/component.dart";
import "package:mony_app/features/category/components/icon.dart";
import "package:mony_app/features/category/page/page.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/gen/assets.gen.dart";

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<CategoryViewModel>();
    final balance = viewModel.balance;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // -> appbar
          AppBarComponent(
            showBackground: false,
            trailing: Row(
              children: [
                // -> button edit
                AppBarButtonComponent(
                  icon: Assets.icons.pencilBold,
                  // onTap: () => onEditPressed(context, account),
                ),
                const SizedBox(width: 4.0),

                // -> button delete
                AppBarButtonComponent(
                  icon: Assets.icons.trashFill,
                  // onTap: () => onDeletePressed(context, account),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
          ),

          // -> content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  CategoryIconComponent(category: viewModel.category),
                ],
              ),
            ),
          ),

          // -> bottom offset
          SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
