part of "../on_app_state_changed.dart";

final class _OnAccountUpdated {
  const _OnAccountUpdated();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventAccountUpdated event,
  ) async {
    final accountSevrice = context.read<DomainAccountService>();
    final transactionService = context.read<DomainTransactionService>();

    final account = event.value;

    final pages = await Future.wait(
      viewModel.pages.map((e) async {
        switch (e) {
          // all accounts
          case final FeedPageStateAllAccounts page:
            final feed = await Future.wait<List<TransactionModel>>(
              List.generate(page.scrollPage + 1, (index) {
                return transactionService.getMany(page: index);
              }),
            );
            final accounts = await accountSevrice.getAll();
            final balances = await accountSevrice.getBalances();

            return Future.value(
              page.copyWith(
                canLoadMore: feed.lastOrNull?.isNotEmpty ?? false,
                feed: feed.fold<List<TransactionModel>>([], (prev, curr) {
                  return prev..addAll(curr);
                }),
                balances: balances,
                accounts: accounts,
              ),
            );

          // single account
          case final FeedPageStateSingleAccount page:
            final feed = List<TransactionModel>.from(
              page.feed.map((e) {
                return e.account.id == account.id
                    ? e.copyWith(account: account.copyWith())
                    : e;
              }),
            );
            final balance = await accountSevrice.getBalance(id: account.id);

            return Future.value(
              page.copyWith(
                feed: feed,
                balance: balance,
                account: account.copyWith(),
              ),
            );
        }
      }),
    );

    viewModel.setProtectedState(() => viewModel.pages = pages);

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      for (final controller in viewModel.scrollControllers) {
        if (!controller.isReady) continue;
        controller.jumpTo(controller.distance);
      }
    });
  }
}
