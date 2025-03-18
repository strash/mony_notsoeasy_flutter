part of "../on_app_state_changed.dart";

final class _OnTransactionDeleted {
  const _OnTransactionDeleted();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventTransactionDeleted event,
  ) async {
    final accountSevrice = context.service<DomainAccountService>();
    final transactionService = context.service<DomainTransactionService>();

    final transaction = event.value;

    final pages = await Future.wait(
      viewModel.pages.map((e) async {
        switch (e) {
          // all accounts page
          case final FeedPageStateAllAccounts page:
            final balances = await accountSevrice.getBalances();
            final feed = await Future.wait(
              List.generate(page.scrollPage + 1, (index) {
                return transactionService.getMany(page: index);
              }),
            );

            return Future.value(
              page.copyWith(
                balances: balances,
                canLoadMore: feed.lastOrNull?.isNotEmpty ?? false,
                feed: feed.fold<List<TransactionModel>>([], (prev, curr) {
                  return prev..addAll(curr);
                }),
              ),
            );

          // single account page
          case final FeedPageStateSingleAccount page:
            final id = page.account.id;
            if (id != transaction.account.id) return Future.value(page);

            final balance = await accountSevrice.getBalance(id: id);
            final feed = await Future.wait(
              List.generate(page.scrollPage + 1, (index) {
                return transactionService.getMany(
                  page: index,
                  accountIds: [id],
                );
              }),
            );

            return Future.value(
              page.copyWith(
                balance: balance,
                canLoadMore: feed.lastOrNull?.isNotEmpty ?? false,
                feed: feed.fold<List<TransactionModel>>([], (prev, curr) {
                  return prev..addAll(curr);
                }),
              ),
            );
        }
      }),
    );

    viewModel.setProtectedState(() => viewModel.pages = pages);
  }
}
