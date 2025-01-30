import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/stats/page/view_model.dart";

class StatsTotalAmountComponent extends StatelessWidget {
  const StatsTotalAmountComponent({super.key});

  String _getCount(int count) {
    final formatter = NumberFormat();
    final formatted = formatter.format(count);
    final res = switch (count.wordCaseHint) {
      EWordCaseHint.nominative => "$formatted транзакция",
      EWordCaseHint.genitive => "$formatted транзакции",
      EWordCaseHint.accusative => "$formatted транзакций",
    };
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<StatsViewModel>();
    final account = viewModel.accountController.value;
    final balance = viewModel.activeAccountBalance;
    final dates = viewModel.exclusiveDateRange;
    final dateRangeDescription = (
      dates.$1,
      dates.$2.subtract(const Duration(days: 1))
    ).transactionsDateRangeDescription;
    final key =
        "${balance?.totalAmount}_${balance?.totalCount}_$dateRangeDescription";

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedSwitcher(
          duration: Durations.short3,
          child: ConstrainedBox(
            key: Key(key),
            constraints: constraints,
            child: SeparatedComponent.list(
              separatorBuilder: (context, index) => const SizedBox(height: 6.0),
              children: [
                // -> amount
                FittedBox(
                  child: Text(
                    account == null || balance == null
                        ? "0"
                        : balance.totalAmount.currency(
                            name: account.currency.name,
                            symbol: account.currency.symbol,
                            showDecimal: viewModel.isCentsVisible,
                          ),
                    style: GoogleFonts.golosText(
                      fontSize: 28.0,
                      height: 1.0,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),

                // -> count
                if (balance != null)
                  Text(
                    _getCount(balance.totalCount),
                    style: GoogleFonts.golosText(
                      fontSize: 16.0,
                      height: 1.0,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                // -> date range
                Text(
                  dateRangeDescription,
                  style: GoogleFonts.golosText(
                    fontSize: 16.0,
                    height: 1.0,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
