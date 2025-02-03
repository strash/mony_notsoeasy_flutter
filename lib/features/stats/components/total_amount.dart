import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/features/stats/page/view_model.dart";

class StatsTotalAmountComponent extends StatelessWidget {
  const StatsTotalAmountComponent({super.key});

  String _getCount(int count) {
    final formatter = NumberFormat();
    final formatted = formatter.format(count);
    return switch (count.wordCaseHint) {
      EWordCaseHint.nominative => "$formatted транзакция",
      EWordCaseHint.genitive => "$formatted транзакции",
      EWordCaseHint.accusative => "$formatted транзакций",
    };
  }

  String _getAmount(
    AccountModel? account,
    AccountBalanceModel? balance,
    bool showDecimal,
  ) {
    if (account == null || balance == null) return "0";
    return balance.totalAmount.currency(
      name: account.currency.name,
      symbol: account.currency.symbol,
      showDecimal: showDecimal,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<StatsViewModel>();
    final account = viewModel.accountController.value;
    final balance = viewModel.balance;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: constraints,
          child: SeparatedComponent.list(
            separatorBuilder: (context, index) => const SizedBox(height: 6.0),
            children: [
              // -> amount
              AnimatedSwitcher(
                duration: Durations.short3,
                child: Row(
                  key: Key((balance?.totalAmount).toString()),
                  children: [
                    FittedBox(
                      child: AnimatedSwitcher(
                        duration: Durations.short3,
                        child: Text(
                          _getAmount(
                            account,
                            balance,
                            viewModel.isCentsVisible,
                          ),
                          style: GoogleFonts.golosText(
                            fontSize: 28.0,
                            height: 1.0,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // -> count
              AnimatedSwitcher(
                duration: Durations.short3,
                child: SizedBox(
                  key: Key((balance?.totalCount).toString()),
                  width: double.infinity,
                  child: Text(
                    _getCount(balance?.totalCount ?? 0),
                    style: GoogleFonts.golosText(
                      fontSize: 14.0,
                      height: 1.0,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
