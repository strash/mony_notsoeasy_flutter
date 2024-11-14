import "package:flutter/widgets.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/transaction/page/view_model.dart";

export "./view_model.dart";

class TransactionPage extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionPage({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return TransactionViewModelBuilder(transaction: transaction);
  }
}
