import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/budgets/page/view.dart";

final class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});

  @override
  ViewModelState<BudgetsPage> createState() => BudgetsViewModel();
}

final class BudgetsViewModel extends ViewModelState<BudgetsPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<BudgetsViewModel>(
      viewModel: this,
      child: const BudgetsView(),
    );
  }
}
