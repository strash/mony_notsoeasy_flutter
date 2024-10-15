import "package:flutter/material.dart";
import "package:mony_app/features/new_expense/page/view_model.dart";

export "./view_model.dart";

class NewExpensePage extends StatelessWidget {
  const NewExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NewExpenseViewModelBuilder();
  }
}
