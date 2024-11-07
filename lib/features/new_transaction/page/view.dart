import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/new_transaction/components/components.dart";

class NewTransactionView extends StatelessWidget {
  const NewTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final viewModel = context.viewModel<NewTransactionViewModel>();

    return Stack(
      fit: StackFit.expand,
      children: [
        // -> background
        const NewTransactionBackgroundComponent(),

        // -> form
        Padding(
          padding:
              EdgeInsets.fromLTRB(10.w, 0.0, 10.w, viewPadding.bottom + 10.h),
          child: Column(
            children: [
              // -> handler
              const BottomSheetHandleComponent(),

              // -> the rest
              Expanded(
                child: Column(
                  children: [
                    // -> type
                    SizedBox(height: 10.h),
                    TabGroupComponent(
                      values: ETransactionType.values,
                      controller: viewModel.typeController,
                    ),
                    SizedBox(height: 40.h),

                    // -> amount
                    const NewTransactionAmountComponent(),
                    SizedBox(height: 20.h),

                    // -> date time
                    const NewTransactionDatetimeComponent(),

                    const Spacer(),

                    // -> note
                    Text("Note"),
                    // SizedBox(height: 30.h),

                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        // -> account
                        const Flexible(child: NewTransactionAccountComponent()),
                        SizedBox(width: 10.w),

                        // -> category
                        const Flexible(
                            child: NewTransactionCategoryComponent()),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // -> tags
                    const NewTransactionTagsComponent(),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),

              // -> keyboard
              const NewTransactionKeyboadrComponent(),
            ],
          ),
        ),
      ],
    );
  }
}
