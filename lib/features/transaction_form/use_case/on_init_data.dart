import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
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
    final tagService = context.read<DomainTagService>();

    final transaction = viewModel.transaction;

    final isKeyboardHintAccepted =
        await prefService.isNewTransactionKeyboardHintAccepted();

    final accounts = await accountService.getAll();

    final expenseCategories =
        await categoryService.getAll(transactionType: ETransactionType.expense);
    final incomeCategories =
        await categoryService.getAll(transactionType: ETransactionType.income);

    if (transaction == null) {
      final lastTransactions = await transactionService.getMany(page: 0);
      viewModel.setProtectedState(() {
        viewModel.accountController.value = lastTransactions.firstOrNull != null
            ? lastTransactions.firstOrNull?.account.copyWith()
            : accounts.firstOrNull?.copyWith();
      });
    } else {
      final tags = await tagService.getAll(
        ids: transaction.tags.map((e) => e.tagId).toList(growable: false),
      );
      viewModel.setProtectedState(() {
        viewModel.attachedTags = tags.map((e) {
          return TransactionTagFormModel(e);
        }).toList(growable: false)
          ..sort((a, b) {
            final indexA =
                transaction.tags.indexWhere((e) => e.tagId == a.model.id);
            final indexB =
                transaction.tags.indexWhere((e) => e.tagId == b.model.id);
            return indexA.compareTo(indexB);
          });
      });
      // NOTE: wait before controller is attached
      WidgetsBinding.instance.addPostFrameCallback((timestamp) {
        if (!context.mounted || !viewModel.tagScrollController.isReady) return;
        // to trigger scroll gradient
        viewModel.tagScrollController.jumpTo(1.0);
        viewModel.tagScrollController.jumpTo(.0);
      });
    }

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
