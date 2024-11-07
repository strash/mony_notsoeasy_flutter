import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/new_transaction/page/view_model.dart";
import "package:provider/provider.dart";

final class OnInitData extends UseCase<Future<void>, NewTransactionViewModel> {
  @override
  Future<void> call(
    BuildContext context, [
    NewTransactionViewModel? viewModel,
  ]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final accountService = context.read<DomainAccountService>();
    final categoryService = context.read<DomainCategoryService>();
    final transactionService = context.read<DomainTransactionService>();
    final tagService = context.read<DomainTagService>();

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

    // TODO: сортировать по последнему использованию и по типу транзакции
    final tags = await tagService.getAll();
    viewModel.displayedTags.value = tags;

    viewModel.setProtectedState(() {
      viewModel.accounts = accounts;
      viewModel.categories = {
        ETransactionType.expense: expenseCategories,
        ETransactionType.income: incomeCategories,
      };
      viewModel.tags = tags;
    });
  }
}
