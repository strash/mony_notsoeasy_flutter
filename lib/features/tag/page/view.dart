import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/tag/components/components.dart";
import "package:mony_app/features/tag/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class TagView extends StatelessWidget {
  const TagView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<TagViewModel>();
    final keyPrefix = "tag_${viewModel.prefix}";
    final tag = viewModel.tag;
    final balance = viewModel.balance;

    final onTagMenuSelected = viewModel<OnTagWithContextMenuSelected>();
    final onTransactionPressed =
        viewModel<OnTransactionWithContextMenuPressed>();
    final onTransactionMenuSelected =
        viewModel<OnTransactionWithContextMenuSelected>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        controller: viewModel.controller,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> appbar
          AppBarComponent(
            trailing: Row(
              children: [
                // -> button edit
                AppBarButtonComponent(
                  icon: Assets.icons.pencilBold,
                  onTap: () {
                    final value = (menu: ETagContextMenuItem.edit, tag: tag);
                    onTagMenuSelected(context, value);
                  },
                ),
                const SizedBox(width: 4.0),

                // -> button delete
                AppBarButtonComponent(
                  icon: Assets.icons.trashFill,
                  onTap: () {
                    final value = (menu: ETagContextMenuItem.delete, tag: tag);
                    onTagMenuSelected(context, value);
                  },
                ),
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
                      child: TagTotalAmountComponent(
                        balance: balance,
                        showDecimal: true,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // -> feed
          TransactionListComponent(
            transactions: viewModel.feed,
            keyPrefix: keyPrefix,
            isCentsVisible: viewModel.isCentsVisible,
            isColorsVisible: viewModel.isColorsVisible,
            isTagsVisible: viewModel.isTagsVisible,
            showFullDate: false,
            emptyStateColor: theme.colorScheme.onSurfaceVariant,
            onTransactionPressed: onTransactionPressed,
            onTransactionMenuSelected: onTransactionMenuSelected,
          ),
        ],
      ),
    );
  }
}
