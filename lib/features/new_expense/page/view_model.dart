import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/new_expense/page/view.dart";

final class NewExpenseViewModelBuilder extends StatefulWidget {
  const NewExpenseViewModelBuilder({super.key});

  @override
  ViewModelState<NewExpenseViewModelBuilder> createState() =>
      NewExpenseViewModel();
}

final class NewExpenseViewModel
    extends ViewModelState<NewExpenseViewModelBuilder> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<NewExpenseViewModel>(
      viewModel: this,
      child: const NewExpenseView(),
    );
  }
}
