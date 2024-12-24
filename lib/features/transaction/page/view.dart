import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
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

    final onEditPressed = viewModel<OnEditTransactionPressed>();
    final onDeletePressed = viewModel<OnDeleteTransactionPressed>();
    final onAccountPressed = viewModel<OnAccountPressed>();
    final onCategoryPressed = viewModel<OnCategoryPressed>();
    final onTagPressed = viewModel<OnTagPressed>();

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
                  onTap: () => onEditPressed(context, transaction),
                ),
                const SizedBox(width: 4.0),

                // -> button delete
                AppBarButtonComponent(
                  icon: Assets.icons.trashFill,
                  onTap: () => onDeletePressed(context, transaction),
                ),
                const SizedBox(width: 8.0),
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
                  TransactionAmountComponent(transaction: transaction),
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
                        onTap: () =>
                            onAccountPressed(context, transaction.account),
                        child: AccountComponent(account: transaction.account),
                      ),

                      // -> category
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () =>
                            onCategoryPressed(context, transaction.category),
                        child: TransactionCategoryComponent(
                          category: transaction.category,
                        ),
                      ),

                      // -> tags
                      TransactionTagsComponent(
                        tags: transaction.tags,
                        onTap: onTagPressed,
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
