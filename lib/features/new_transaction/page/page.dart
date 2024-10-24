import "package:flutter/material.dart";
import "package:mony_app/features/new_transaction/page/view_model.dart";

export "./view_model.dart";

class NewTransactionPage extends StatelessWidget {
  const NewTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NewTransactionViewModelBuilder();
  }
}
