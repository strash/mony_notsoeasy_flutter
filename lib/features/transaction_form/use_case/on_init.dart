import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/common/extensions/scroll_controller.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";

final class OnInit extends UseCase<Future<void>, TransactionFormViewModel> {
  @override
  Future<void> call(
    BuildContext context, [
    TransactionFormViewModel? viewModel,
  ]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final accountService = context.service<DomainAccountService>();
    final categoryService = context.service<DomainCategoryService>();
    final transactionService = context.service<DomainTransactionService>();

    final transaction = viewModel.transaction;
    final accounts = await accountService.getAll();

    final Map<ETransactionType, List<CategoryModel>> categories = {
      for (final type in ETransactionType.values)
        type: await categoryService.getAll(transactionType: type),
    };

    switch (transaction == null) {
      case true:
        if (viewModel.account == null) {
          final recentExpence = await transactionService.findRecentOneBy(
            transactionType: ETransactionType.expense,
          );
          final recentIncome = await transactionService.findRecentOneBy(
            transactionType: ETransactionType.income,
          );
          final recentAccount = recentExpence?.account ?? recentIncome?.account;
          viewModel.accountController.value =
              recentAccount?.copyWith() ?? accounts.firstOrNull?.copyWith();
          viewModel.expenseCategoryController.value =
              recentExpence?.category.copyWith();
          viewModel.incomeCategoryController.value =
              recentIncome?.category.copyWith();
        } else {
          viewModel.accountController.value = viewModel.account!.copyWith();
          final recentExpence = await transactionService.findRecentOneBy(
            accountId: viewModel.account?.id,
            transactionType: ETransactionType.expense,
          );
          final recentIncome = await transactionService.findRecentOneBy(
            accountId: viewModel.account?.id,
            transactionType: ETransactionType.income,
          );
          viewModel.expenseCategoryController.value =
              recentExpence?.category.copyWith();
          viewModel.incomeCategoryController.value =
              recentIncome?.category.copyWith();
        }

      case false:
        viewModel.accountController.value =
            viewModel.account?.copyWith() ?? viewModel.transaction?.account;
        viewModel.attachedTags = transaction!.tags
            .map((e) => TransactionTagVariantModel(e))
            .toList(growable: false);
        // NOTE: wait before controller is attached
        WidgetsBinding.instance.addPostFrameCallback((timestamp) {
          if (!context.mounted || !viewModel.tagScrollController.isReady) {
            return;
          }
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
