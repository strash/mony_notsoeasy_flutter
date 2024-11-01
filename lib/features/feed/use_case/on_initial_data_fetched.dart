import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:provider/provider.dart";

final class OnInitialDataFetched extends UseCase<Future<void>, FeedViewModel>
    with DataFetchMixin {
  @override
  Future<void> call(BuildContext context, [FeedViewModel? viewModel]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final accountService = context.read<DomainAccountService>();
    final transactionService = context.read<DomainTransactionService>();

    final List<FeedPageState> pages = [];
    final accounts = await accountService.getAll();

    if (accounts.length > 1) {
      final transactions = await transactionService.getMany(page: 0)
        ..sort((a, b) => b.date.compareTo(a.date));
      pages.add(
        FeedPageStateAllAccounts(
          page: 0,
          canLoadMore: true,
          feed: transformToFeed(transactions),
          accounts: accounts,
        ),
      );
    }

    for (final account in accounts) {
      final transactions =
          await transactionService.getMany(page: 0, accountId: account.id)
            ..sort((a, b) => b.date.compareTo(a.date));
      pages.add(
        FeedPageStateSingleAccount(
          page: 0,
          canLoadMore: true,
          feed: transformToFeed(transactions),
          account: account,
        ),
      );
    }

    viewModel.setProtectedState(() {
      viewModel.pages = pages;
    });
  }
}
