part of "../on_app_state_changed.dart";

final class _OnAccountBalanceExchanged {
  const _OnAccountBalanceExchanged();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventAccountBalanceExchanged event,
  ) async {
    final accountSevrice = context.service<DomainAccountService>();

    final (left, right) = event.value;

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
                    if (e.account.id == left.id) {
                      return e.copyWith(account: left.copyWith());
                    } else if (e.account.id == right.id) {
                      return e.copyWith(account: right.copyWith());
                    } else {
                      return e;
                    }
                  }),
                ),
                balances: balances,
                accounts: accounts,
              ),
            );

          // single account
          case final FeedPageStateSingleAccount page:
            AccountModel? account;
            if (page.account.id == left.id) {
              account = left;
            } else if (page.account.id == right.id) {
              account = right;
            }
            if (account == null) return Future.value(page);

            final balance = await accountSevrice.getBalance(id: account.id);

            return Future.value(
              page.copyWith(
                feed: List<TransactionModel>.from(
                  page.feed.map((e) {
                    return e.copyWith(account: account!.copyWith());
                  }),
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
