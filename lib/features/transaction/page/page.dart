import "package:flutter/widgets.dart";
import "package:mony_app/features/transaction/page/view_model.dart";

export "./view_model.dart";

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionViewModelBuilder();
  }
}
