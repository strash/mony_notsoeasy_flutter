import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/new_transaction/page/view_model.dart";

class NewTransactionAmountComponent extends StatelessWidget {
  const NewTransactionAmountComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<NewTransactionViewModel>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: SizedBox.fromSize(
        size: const Size.fromHeight(65),
        child: FittedBox(
          alignment: Alignment.bottomCenter,
          child: DefaultTextStyle(
            style: GoogleFonts.golosText(
              fontSize: 50.sp,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // -> sign
                ListenableBuilder(
                  listenable: viewModel.typeController,
                  builder: (context, child) {
                    return Text(
                      switch (viewModel.typeController.value) {
                        ETransactionType.expense => "-",
                        ETransactionType.income => "+",
                      },
                    );
                  },
                ),

                // -> amount value
                const Text("1490.23"),

                // -> currency sign
                ListenableBuilder(
                  listenable: viewModel.accountController,
                  builder: (context, child) {
                    final color = theme.colorScheme.onSurfaceVariant;
                    final copyWith = DefaultTextStyle.of(context)
                        .style
                        .copyWith(color: color.withOpacity(.5));
                    final String symbol;
                    if (viewModel.accountController.value != null) {
                      symbol =
                          viewModel.accountController.value!.currency.symbol ??
                              viewModel.accountController.value!.currency.code;
                    } else {
                      symbol = "P";
                    }

                    return Text(" $symbol", style: copyWith);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
