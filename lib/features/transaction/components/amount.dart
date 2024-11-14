import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction.dart";

class TransactionAmountComponent extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionAmountComponent({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: FittedBox(
        child: Text(
          transaction.amount.currency(
            name: transaction.account.currency.name,
            symbol: transaction.account.currency.symbol,
          ),
          textAlign: TextAlign.center,
          style: GoogleFonts.golosText(
            fontSize: 40.sp,
            height: 1.1,
            fontWeight: FontWeight.w600,
            color: transaction.amount.isNegative
                ? theme.colorScheme.onSurface
                : theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
