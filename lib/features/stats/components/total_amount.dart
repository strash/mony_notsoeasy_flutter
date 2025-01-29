import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/stats/page/view_model.dart";

class StatsTotalAmountComponent extends StatelessWidget {
  const StatsTotalAmountComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<StatsViewModel>();
    final account = viewModel.accountController.value;
    final totalAmount = viewModel.transactions.fold<double>(.0, (prev, curr) {
      return prev + curr.amount;
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedSwitcher(
          duration: Durations.short3,
          child: SizedBox(
            key: Key(totalAmount.toString()),
            width: constraints.maxWidth,
            child: Text(
              account == null
                  ? "Не выбран счет"
                  : totalAmount.currency(
                      name: account.currency.name,
                      symbol: account.currency.symbol,
                      showDecimal: viewModel.isCentsVisible,
                    ),
              style: GoogleFonts.golosText(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        );
      },
    );
  }
}
