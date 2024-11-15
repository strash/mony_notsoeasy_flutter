import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/transaction_form/components/components.dart";

class TransactionFormView extends StatelessWidget {
  const TransactionFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final viewModel = context.viewModel<TransactionFormViewModel>();

    return Column(
      children: [
        // -> the rest
        Expanded(
          child: Column(
            children: [
              // -> appbar
              AppBarComponent(
                useSliver: false,
                automaticallyImplyLeading: false,
                showDragHandle: true,
                // -> type
                title: Center(
                  child: TabGroupComponent(
                    values: ETransactionType.values,
                    controller: viewModel.typeController,
                  ),
                ),
                trailing: const CloseButtonComponent(),
              ),
              const Spacer(),

              // -> amount
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: const TransactionFormAmountComponent(),
              ),
              const Spacer(),

              // -> date time
              const TransactionFormDatetimeComponent(),
              SizedBox(height: 20.h),

              // -> account and category
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    // -> account
                    const Flexible(child: TransactionFormAccountComponent()),
                    SizedBox(width: 10.w),

                    // -> category
                    const Flexible(
                      child: TransactionFormCategoryComponent(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),

              // -> tags
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: const TransactionFormTagsComponent(),
              ),
              SizedBox(height: 15.h),

              // -> note
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: const TransactionFormNoteComponent(),
              ),
              SizedBox(height: 15.h),
            ],
          ),
        ),

        // -> keyboard
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const TransactionFormKeyboadrComponent(),
        ),

        // -> bottom offset
        SizedBox(height: viewPadding.bottom + 10.h),
      ],
    );
  }
}
