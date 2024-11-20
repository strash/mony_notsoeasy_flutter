import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/appbar_button/component.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/transaction/components/components.dart";
import "package:mony_app/features/transaction/page/page.dart";
import "package:mony_app/gen/assets.gen.dart";

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomOffset = NavbarView.bottomOffset(context);

    final viewModel = context.viewModel<TransactionViewModel>();
    final onEditPressed = viewModel<OnEditTransactionPressed>();
    final onDeletePressed = viewModel<OnDeleteTransactionPressed>();
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
                  color: theme.colorScheme.primary,
                  onTap: () => onEditPressed(context, transaction),
                ),
                SizedBox(width: 4.w),

                // -> button delete
                AppBarButtonComponent(
                  icon: Assets.icons.trashFill,
                  color: theme.colorScheme.primary,
                  onTap: () => onDeletePressed(context, transaction),
                ),
                SizedBox(width: 8.w),
              ],
            ),
          ),

          // -> content
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                  SizedBox(height: 40.h),

                  // -> amount
                  TransactionAmountComponent(transaction: transaction),
                  SizedBox(height: 10.h),

                  // -> date
                  TransactionDateComponent(date: transaction.date),
                  SizedBox(height: 40.h),

                  // TODO: открывать экран аккаунта
                  // -> account
                  TransactionAccountComponent(account: transaction.account),

                  // TODO: открывать экран тега при клике на тег
                  // -> tags
                  TransactionTagsComponent(tags: transaction.tags),
                  SizedBox(height: 30.h),

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
