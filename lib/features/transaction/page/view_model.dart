import "package:flutter/widgets.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/transaction/page/view.dart";

final class TransactionViewModelBuilder extends StatefulWidget {
  const TransactionViewModelBuilder({super.key});

  @override
  ViewModelState<TransactionViewModelBuilder> createState() =>
      TransactionViewModel();
}

final class TransactionViewModel
    extends ViewModelState<TransactionViewModelBuilder> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<TransactionViewModel>(
      viewModel: this,
      child: const TransactionView(),
    );
  }
}
