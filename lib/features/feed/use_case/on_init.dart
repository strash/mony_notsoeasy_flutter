import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/page/view_model.dart";

final class OnInit extends UseCase<Future<void>, FeedViewModel> {
  @override
  Future<void> call(BuildContext context, [FeedViewModel? viewModel]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final accountService = context.service<DomainAccountService>();
    final transactionService = context.service<DomainTransactionService>();

    final List<FeedPageState> pages = [];
    final accounts = await accountService.getAll();
    final balances = await accountService.getBalances();

    if (accounts.length > 1) {
      final transactions = await transactionService.getMany(page: 0);
      pages.add(
        FeedPageStateAllAccounts(
          scrollPage: 0,
          canLoadMore: true,
          feed: transactions,
          accounts: accounts,
          balances: balances,
        ),
      );
    }

    for (final account in accounts) {
      final transactions = await transactionService.getMany(
        page: 0,
        accountIds: [account.id],
      );
      pages.add(
        FeedPageStateSingleAccount(
          scrollPage: 0,
          canLoadMore: true,
          feed: transactions,
          account: account,
          balance: balances.singleWhere((e) => e.id == account.id),
        ),
      );
    }

    viewModel.setProtectedState(() {
      viewModel.clearScrollControllers();
      viewModel.pages = pages;
      for (final (index, _) in pages.indexed) {
        viewModel.addPageScroll(index);
      }
    });
  }
}
