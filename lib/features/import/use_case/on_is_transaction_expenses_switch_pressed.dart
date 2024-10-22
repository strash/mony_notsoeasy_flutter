import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/page/page.dart";

final class OnIsTransactionExpensesSwitchPressed
    extends UseCase<void, TTransactionsByType> {
  @override
  void call(BuildContext context, [TTransactionsByType? transactionsByType]) {
    if (transactionsByType == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<ImportViewModel>();
    viewModel.setProtectedState(() {
      viewModel.isTransactionsExpenses = !viewModel.isTransactionsExpenses;
    });
    viewModel.mapTransactionTypes();
  }
}
