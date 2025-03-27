import "package:flutter/material.dart";

class BudgetsView extends StatelessWidget {
  const BudgetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // TODO: i18n
      body: Center(child: Text("Budgets")),
    );
  }
}
