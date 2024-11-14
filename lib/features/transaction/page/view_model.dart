import "package:flutter/widgets.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/transaction/page/view.dart";

final class TransactionViewModelBuilder extends StatefulWidget {
  final TransactionModel transaction;

  const TransactionViewModelBuilder({
    super.key,
    required this.transaction,
  });

  @override
  ViewModelState<TransactionViewModelBuilder> createState() =>
      TransactionViewModel();
}

final class TransactionViewModel
    extends ViewModelState<TransactionViewModelBuilder> {
  TransactionModel get transaction => widget.transaction;

  // TODO: слушать app events на удаление транзакции, счета, категории и
  // закрывать экран, если удалена транзакция или счет или категория

  @override
  Widget build(BuildContext context) {
    return ViewModel<TransactionViewModel>(
      viewModel: this,
      child: const TransactionView(),
    );
  }
}
