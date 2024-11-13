import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";
import "package:provider/provider.dart";

final class OnInitData extends UseCase<Future<void>, TransactionFormViewModel> {
  @override
  Future<void> call(
    BuildContext context, [
    TransactionFormViewModel? viewModel,
  ]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final prefService = context.read<DomainSharedPrefenecesService>();
    final accountService = context.read<DomainAccountService>();
    final categoryService = context.read<DomainCategoryService>();
    final transactionService = context.read<DomainTransactionService>();

    final accounts = await accountService.getAll();

    final expenseCategories =
        await categoryService.getAll(transactionType: ETransactionType.expense);
    final incomeCategories =
        await categoryService.getAll(transactionType: ETransactionType.income);

    final lastTransactions = await transactionService.getMany(page: 0);
    viewModel.setProtectedState(() {
      viewModel.accountController.value = lastTransactions.firstOrNull != null
          ? lastTransactions.firstOrNull?.account.copyWith()
          : accounts.firstOrNull?.copyWith();
    });

    final isKeyboardHintAccepted =
        await prefService.isNewTransactionKeyboardHintAccepted();

    viewModel.setProtectedState(() {
      viewModel.accounts = accounts;
      viewModel.categories = {
        ETransactionType.expense: expenseCategories,
        ETransactionType.income: incomeCategories,
      };
      viewModel.isKeyboardHintAccepted = isKeyboardHintAccepted;
    });
  }
}
