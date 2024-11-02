import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/new_transaction/page/page.dart";
import "package:mony_app/features/new_transaction/page/view.dart";

export "../use_case/use_case.dart";

final class NewTransactionViewModelBuilder extends StatefulWidget {
  const NewTransactionViewModelBuilder({super.key});

  @override
  ViewModelState<NewTransactionViewModelBuilder> createState() =>
      NewTransactionViewModel();
}

final class NewTransactionViewModel
    extends ViewModelState<NewTransactionViewModelBuilder> {
  ETransactionType activeType = ETransactionType.defaultValue;

  @override
  Widget build(BuildContext context) {
    return ViewModel<NewTransactionViewModel>(
      viewModel: this,
      useCases: [
        () => OnTypeSwitched(),
      ],
      child: const NewTransactionView(),
    );
  }
}
