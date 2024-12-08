part of "../on_app_state_changed.dart";

final class _OnTransactionDeleted {
  const _OnTransactionDeleted();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventTransactionDeleted event,
  ) async {
    final accountSevrice = context.read<DomainAccountService>();

    final transaction = event.value;

    final pages = await Future.wait(
      viewModel.pages.map((e) async {
        switch (e) {
          // all accounts page
          case final FeedPageStateAllAccounts page:
            final balances = await accountSevrice.getBalances();

            return Future.value(
              page.copyWith(
                balances: balances,
                canLoadMore: true,
                feed: List<TransactionModel>.from(
                  page.feed.where((e) => e.id != transaction.id),
                ),
              ),
            );

          // single account page
          case final FeedPageStateSingleAccount page:
            final id = page.account.id;

            if (id != transaction.account.id) return Future.value(page);

            final balance = await accountSevrice.getBalance(id: id);

            return Future.value(
              page.copyWith(
                balance: balance,
                canLoadMore: true,
                feed: List<TransactionModel>.from(
                  page.feed.where((e) => e.id != transaction.id),
                ),
              ),
            );
        }
      }),
    );

    viewModel.setProtectedState(() => viewModel.pages = pages);
  }
}
