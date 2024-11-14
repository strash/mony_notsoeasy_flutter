import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/transaction/components/components.dart";
import "package:mony_app/features/transaction/page/page.dart";

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.paddingOf(context);
    final bottomOffset = viewPadding.bottom +
        NavbarView.kBottomMargin * 2.0 +
        NavbarView.kTabHeight +
        50.h;

    final viewModel = context.viewModel<TransactionViewModel>();
    final transaction = viewModel.transaction;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> appbar
          const AppBarComponent(showBackground: false),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
