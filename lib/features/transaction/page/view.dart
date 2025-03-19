import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account/component.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/appbar_button/component.dart";
import "package:mony_app/components/category/component.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/components/transaction_with_context_menu/component.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/transaction/components/components.dart";
import "package:mony_app/features/transaction/transaction.dart";
import "package:mony_app/features/transaction/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<TransactionViewModel>();
    final transaction = viewModel.transaction;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
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
                    final value = (
                      menu: ETransactionContextMenuItem.edit,
                      transaction: transaction,
                    );
                    viewModel<OnTransactionWithContextMenuSelected>()(
                      context,
                      value,
                    );
                  },
                ),
                const SizedBox(width: 4.0),

                // -> button delete
                AppBarButtonComponent(
                  icon: Assets.icons.trashFill,
                  onTap: () {
                    final value = (
                      menu: ETransactionContextMenuItem.delete,
                      transaction: transaction,
                    );
                    viewModel<OnTransactionWithContextMenuSelected>()(
                      context,
                      value,
                    );
                  },
                ),
              ],
            ),
          ),

          // -> content
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, bottomOffset),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -> amount
                  TransactionAmountComponent(
                    transaction: transaction,
                    showDecimal: true,
                  ),
                  const SizedBox(height: 10.0),

                  // -> date
                  TransactionDateComponent(date: transaction.date),
                  const SizedBox(height: 40.0),

                  SeparatedComponent.list(
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 30.0);
                    },
                    children: [
                      // -> account
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          viewModel<OnAccountPressed>()(
                            context,
                            transaction.account,
                          );
                        },
                        child: AccountComponent(
                          account: transaction.account,
                          balance: viewModel.balance,
                          showColors: viewModel.isColorsVisible,
                          showDecimal: viewModel.isCentsVisible,
                        ),
                      ),

                      // -> category
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          viewModel<OnCategoryPressed>()(
                            context,
                            transaction.category,
                          );
                        },
                        child: CategoryComponent(
                          category: transaction.category,
                          showColors: viewModel.isColorsVisible,
                        ),
                      ),

                      // -> tags
                      TransactionTagsComponent(
                        tags: transaction.tags,
                        onTap: viewModel<OnTagPressed>(),
                      ),

                      // -> note
                      if (transaction.note.isNotEmpty)
                        TransactionNoteComponent(note: transaction.note),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
