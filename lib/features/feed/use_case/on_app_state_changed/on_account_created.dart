part of "../on_app_state_changed.dart";

final class _OnAccountCreated {
  const _OnAccountCreated();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventAccountCreated event,
  ) async {
    final accountSevrice = context.read<DomainAccountService>();
    final transactionService = context.read<DomainTransactionService>();

    final account = event.value;

    final pages = await Future.wait(
      viewModel.pages.map((e) async {
        switch (e) {
          case final FeedPageStateAllAccounts page:
            final balances = await accountSevrice.getBalances();
            return Future.value(page.copyWith(balances: balances));
          case FeedPageStateSingleAccount():
            return Future.value(e);
        }
      }),
    );

    {
      final balances = await accountSevrice.getBalances(ids: [account.id]);
      viewModel.addPageScroll(viewModel.pages.length);
      pages.add(
        FeedPageStateSingleAccount(
          scrollPage: 0,
          canLoadMore: true,
          feed: const [],
          account: account.copyWith(),
          balance: balances.first,
        ),
      );
    }

    if (pages.whereType<FeedPageStateAllAccounts>().isEmpty) {
      final accounts = await accountSevrice.getAll();
      final transactions = await transactionService.getMany(page: 0);
      final balances = await accountSevrice.getBalances();
      viewModel.addPageScroll(0);
      final page = FeedPageStateAllAccounts(
        scrollPage: 1,
        canLoadMore: true,
        feed: transactions,
        accounts: accounts,
        balances: balances,
      );
      pages.insert(0, page);
    }

    viewModel.setProtectedState(() {
      viewModel.pages = pages;
    });

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      viewModel.openPage(viewModel.pages.length - 1);
    });
  }
}
