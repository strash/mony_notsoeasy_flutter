import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/appbar_button/component.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/tag/components/components.dart";
import "package:mony_app/features/tag/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class TagView extends StatelessWidget {
  const TagView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<TagViewModel>();
    final tag = viewModel.tag;
    final balance = viewModel.balance;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> appbar
          AppBarComponent(
            showBackground: false,
            trailing: Row(
              children: [
                // -> button edit
                AppBarButtonComponent(
                  icon: Assets.icons.pencilBold,
                  // TODO
                  // onTap: () => onEditPressed(context, transaction),
                ),
                const SizedBox(width: 4.0),

                // -> button delete
                AppBarButtonComponent(
                  icon: Assets.icons.trashFill,
                  // TODO
                  // onTap: () => onDeletePressed(context, transaction),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -> tag
                  TagTagComponent(tag: tag),
                  const SizedBox(height: 40.0),

                  // -> balance
                  if (balance != null && balance.totalAmount.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: TagTotalAmountComponent(balance: balance),
                    ),
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