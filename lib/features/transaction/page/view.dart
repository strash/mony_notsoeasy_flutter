import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account/component.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/appbar_button/component.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/transaction/components/components.dart";
import "package:mony_app/features/transaction/page/page.dart";
import "package:mony_app/features/transaction/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<TransactionViewModel>();
    final onEditPressed = viewModel<OnEditTransactionPressed>();
    final onDeletePressed = viewModel<OnDeleteTransactionPressed>();
    final onAccountPressed = viewModel<OnAccountPressed>();
    final transaction = viewModel.transaction;

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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TODO: открывать экран категории
                  // -> category
                  TransactionCategoryComponent(
                    category: transaction.category,
                  ),
                  const SizedBox(height: 40.0),

                  // -> amount
                  TransactionAmountComponent(transaction: transaction),
                  const SizedBox(height: 10.0),

                  // -> date
                  TransactionDateComponent(date: transaction.date),
                  const SizedBox(height: 40.0),

                  // -> account
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onAccountPressed(context, transaction.account),
                    child: AccountComponent(account: transaction.account),
                  ),
                  const SizedBox(height: 30.0),

                  // TODO: открывать экран тега при клике на тег
                  // -> tags
                  TransactionTagsComponent(tags: transaction.tags),
                  const SizedBox(height: 30.0),

                  // -> note
                  if (transaction.note.isNotEmpty)
                    TransactionNoteComponent(note: transaction.note),

                  // -> bottom offset
                  SizedBox(height: bottomOffset),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
