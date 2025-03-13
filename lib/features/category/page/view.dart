import "package:flutter/material.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/category/category.dart";
import "package:mony_app/features/category/components/components.dart";
import "package:mony_app/features/category/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();

    final viewModel = context.viewModel<CategoryViewModel>();
    final keyPrefix = "category_${viewModel.prefix}";
    final category = viewModel.category;
    final balance = viewModel.balance;

    final onTransactionPressed = viewModel<OnTransactionPressed>();
    final onTransactionMenuSelected =
        viewModel<OnTransactionWithContextMenuSelectedUseCase>();
    final onEditPressed = viewModel<OnEditPressed>();
    final onDeletePressed = viewModel<OnDeletePressed>();

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
                  onTap: () => onEditPressed(context, category),
                ),
                const SizedBox(width: 4.0),

                // -> button delete
                AppBarButtonComponent(
                  icon: Assets.icons.trashFill,
                  onTap: () => onDeletePressed(context, category),
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
                  // -> icon
                  CategoryIconComponent(
                    category: viewModel.category,
                    showColors: viewModel.isColorsVisible,
                  ),
                  const SizedBox(height: 40.0),

                  // -> balance
                  if (balance != null && balance.totalAmount.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: CategoryTotalAmountComponent(
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
            emptyStateColor:
                ex?.from(category.colorName).color ??
                theme.colorScheme.onSurface,
            onTransactionPressed: onTransactionPressed,
            onTransactionMenuSelected: onTransactionMenuSelected,
          ),
        ],
      ),
    );
  }
}
