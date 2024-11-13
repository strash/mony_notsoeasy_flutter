import "package:flutter/material.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";

export "./view_model.dart";

class TransactionFormPage extends StatelessWidget {
  const TransactionFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionFormViewModelBuilder();
  }
}
