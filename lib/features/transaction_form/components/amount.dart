import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class TransactionFormAmountComponent extends StatelessWidget {
  const TransactionFormAmountComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<TransactionFormViewModel>();
    final locale = Localizations.localeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox.fromSize(
        size: const Size.fromHeight(65),
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // -> sign
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ListenableBuilder(
                  listenable: viewModel.typeController,
                  builder: (context, child) {
                    final colorScheme = ColorScheme.of(context);

                    return AnimatedSwitcher(
                      duration: Durations.short4,
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      child: SvgPicture.asset(
                        key: ValueKey(viewModel.typeController.value),
                        switch (viewModel.typeController.value) {
                          ETransactionType.expense => Assets.icons.minus,
                          ETransactionType.income => Assets.icons.plus,
                        },
                        width: 36.0,
                        height: 36.0,
                        colorFilter: ColorFilter.mode(
                          viewModel.isColorsVisible
                              ? switch (viewModel.typeController.value) {
                                ETransactionType.expense => colorScheme.error,
                                ETransactionType.income =>
                                  colorScheme.secondary,
                              }
                              : colorScheme.onSurfaceVariant,
                          BlendMode.srcIn,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // -> amount value
              ListenableBuilder(
                listenable: viewModel.amountNotifier,
                builder: (context, child) {
                  return NumericText(
                    viewModel.amountDescription(locale.languageCode),
                    style: GoogleFonts.golosText(
                      fontSize: 50.0,
                      color: ColorScheme.of(context).onSurface,
                      height: 1.0,
                      fontWeight: FontWeight.w400,
                      textStyle: TextTheme.of(context).bodyMedium,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
