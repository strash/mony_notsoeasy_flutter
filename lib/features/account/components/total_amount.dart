import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account/page/view_model.dart";

class AccountTotalAmountComponent extends StatelessWidget {
  final AccountBalanceModel balance;

  const AccountTotalAmountComponent({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<AccountViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -> title
        Text(
          "Сумма транзакций",
          style: GoogleFonts.golosText(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10.0),

        // -> amount
        Text(
          balance.totalAmount.currency(
            name: balance.currency.name,
            symbol: balance.currency.symbol,
          ),
          style: GoogleFonts.golosText(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12.0),

        // -> transactions date range
        Text(
          viewModel.transactionsCountDescription,
          style: GoogleFonts.golosText(
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 3.0),

        // -> transactions date range
        Text(
          viewModel.transactionsDateRangeDescription,
          style: GoogleFonts.golosText(
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
