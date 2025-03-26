import "package:flutter/material.dart";

class BudgetsView extends StatelessWidget {
  const BudgetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(child: Text("Budgets")),
    );
  }
}
