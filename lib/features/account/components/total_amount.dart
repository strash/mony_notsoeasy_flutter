import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
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

    return SeparatedComponent.list(
      separatorBuilder: (context) => const SizedBox(height: 10.0),
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

        SeparatedComponent.list(
          separatorBuilder: (context) => const SizedBox(height: 3.0),
          children: [
            // -> transactions date range
            Text(
              viewModel.balance?.transactionsCountDescription ?? "",
              style: GoogleFonts.golosText(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            // -> transactions date range
            Text(
              viewModel.balance?.transactionsDateRangeDescription ?? "",
              style: GoogleFonts.golosText(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
