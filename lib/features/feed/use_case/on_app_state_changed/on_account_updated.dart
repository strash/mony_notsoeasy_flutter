part of "../on_app_state_changed.dart";

final class _OnAccountUpdated {
  const _OnAccountUpdated();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventAccountUpdated event,
  ) async {
    final accountSevrice = context.read<DomainAccountService>();

    final account = event.value;
    final id = account.id;

    final pages = await Future.wait(
      viewModel.pages.map((e) async {
        switch (e) {
          // all accounts
          case final FeedPageStateAllAccounts page:
            final balances = await accountSevrice.getBalances();
            final accounts = await accountSevrice.getAll();

            return Future.value(
              page.copyWith(
                feed: List<TransactionModel>.from(
                  page.feed.map((e) {
                    return e.account.id == id
                        ? e.copyWith(account: account.copyWith())
                        : e;
                  }),
                ),
                balances: balances,
                accounts: accounts,
              ),
            );

          // single account
          case final FeedPageStateSingleAccount page:
            if (page.account.id != id) return Future.value(page);
            final balance = await accountSevrice.getBalance(id: id);

            return Future.value(
              page.copyWith(
                feed: List<TransactionModel>.from(
                  page.feed.map((e) => e.copyWith(account: account.copyWith())),
                ),
                balance: balance,
                account: account.copyWith(),
              ),
            );
        }
      }),
    );

    viewModel.setProtectedState(() => viewModel.pages = pages);
  }
}
