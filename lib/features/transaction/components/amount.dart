import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction.dart";

class TransactionAmountComponent extends StatelessWidget {
  final TransactionModel transaction;
  final bool showDecimal;

  const TransactionAmountComponent({
    super.key,
    required this.transaction,
    required this.showDecimal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final locale = Localizations.localeOf(context);

    return Center(
      child: FittedBox(
        child: NumericText(
          transaction.amount.currency(
            locale: locale.languageCode,
            name: transaction.account.currency.name,
            symbol: transaction.account.currency.symbol,
            showDecimal: showDecimal,
          ),
          textAlign: TextAlign.center,
          style: GoogleFonts.golosText(
            fontSize: 40.0,
            height: 1.4,
            fontWeight: FontWeight.w600,
            color:
                transaction.amount.isNegative
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
