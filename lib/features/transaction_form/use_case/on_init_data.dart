import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/scroll_controller.dart";
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

    final accountService = context.read<DomainAccountService>();
    final categoryService = context.read<DomainCategoryService>();
    final transactionService = context.read<DomainTransactionService>();

    final transaction = viewModel.transaction;
    final accounts = await accountService.getAll();

    final Map<ETransactionType, List<CategoryModel>> categories = {
      for (final type in ETransactionType.values)
        type: await categoryService.getAll(transactionType: type),
    };

    if (transaction == null) {
      if (viewModel.account == null) {
        final lastTransactions = await transactionService.getMany(page: 0);
        final hasAccount = lastTransactions.firstOrNull != null;
        viewModel.accountController.value =
            hasAccount
                ? lastTransactions.first.account.copyWith()
                : accounts.firstOrNull?.copyWith();
      } else {
        viewModel.accountController.value = viewModel.account!.copyWith();
      }
    } else {
      viewModel.accountController.value =
          viewModel.account?.copyWith() ?? viewModel.transaction?.account;
      viewModel.setProtectedState(() {
        viewModel.attachedTags = transaction.tags
            .map((e) => TransactionTagVariantModel(e))
            .toList(growable: false);
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
      viewModel.categories = categories;
    });
  }
}
