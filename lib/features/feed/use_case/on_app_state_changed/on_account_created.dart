part of "../on_app_state_changed.dart";

final class _OnAccountCreated {
  const _OnAccountCreated();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventAccountCreated event,
  ) async {
    final accountService = context.service<DomainAccountService>();
    final transactionService = context.service<DomainTransactionService>();

    final account = event.value;

    // update all accounts page
    final pages = await Future.wait<FeedPageState>(
      viewModel.pages.map((e) async {
        switch (e) {
          case final FeedPageStateAllAccounts page:
            final accounts = await accountService.getAll();
            final balances = await accountService.getBalances();
            return Future.value(
              page.copyWith(accounts: accounts, balances: balances),
            );
          case FeedPageStateSingleAccount():
            return Future.value(e);
        }
      }),
    );

    // create new account page
    final balance = await accountService.getBalance(id: account.id);
    if (balance != null) {
      viewModel.addPageScroll(viewModel.pages.length);
      pages.add(
        FeedPageStateSingleAccount(
          scrollPage: 0,
          canLoadMore: true,
          feed: const [],
          account: account.copyWith(),
          balance: balance,
        ),
      );
    }

    // create all accounts page
    if (pages.whereType<FeedPageStateSingleAccount>().length > 1 &&
        pages.whereType<FeedPageStateAllAccounts>().isEmpty) {
      const allPagesIdx = 0;
      viewModel.addPageScroll(allPagesIdx);
      final feed = await transactionService.getMany(page: 0);
      final page = FeedPageStateAllAccounts(
        scrollPage: 1,
        canLoadMore: feed.isNotEmpty,
        feed: feed,
        accounts: await accountService.getAll(),
        balances: await accountService.getBalances(),
      );
      pages.insert(allPagesIdx, page);
    }

    viewModel.setProtectedState(() => viewModel.pages = pages);

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      viewModel.openPage(viewModel.pages.length - 1);
    });
  }
}
