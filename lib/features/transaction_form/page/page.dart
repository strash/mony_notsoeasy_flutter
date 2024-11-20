import "package:flutter/material.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";

export "./view_model.dart";

class TransactionFormPage extends StatelessWidget {
  final TransactionModel? transaction;
  final AccountModel? account;

  const TransactionFormPage({
    super.key,
    this.transaction,
    this.account,
  });

  @override
  Widget build(BuildContext context) {
    return TransactionFormViewModelBuilder(
      transaction: transaction,
      account: account,
    );
  }
}
