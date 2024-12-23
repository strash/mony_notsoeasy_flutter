part of "../on_app_state_changed.dart";

final class _OnAccountDeleted {
  const _OnAccountDeleted();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventAccountDeleted event,
  ) async {
    // NOTE: navigator will open start screen, so we are doing nothing with the
    // only page that was deleted
    if (viewModel.pages.length == 1) return;

    final accountSevrice = context.read<DomainAccountService>();
    final transactionService = context.read<DomainTransactionService>();

    final account = event.value;

    final pageIndex = viewModel.pages.indexWhere((e) {
      return e is FeedPageStateSingleAccount && e.account.id == account.id;
    });
    if (pageIndex == -1) return;

    viewModel.removePageScroll(pageIndex);

    final pages = await Future.wait(
      viewModel.pages.map((e) async {
        switch (e) {
          // all accounts page
          case final FeedPageStateAllAccounts page:
            final balances = await accountSevrice.getBalances();
            final List<List<TransactionModel>> feed = [];
            int scrollPage = 0;
            do {
              feed.add(await transactionService.getMany(page: scrollPage++));
            } while (scrollPage <= page.scrollPage &&
                (feed.lastOrNull?.isNotEmpty ?? false));

            return Future.value(
              page.copyWith(
                balances: balances,
                scrollPage: scrollPage,
                canLoadMore: feed.lastOrNull?.isNotEmpty ?? false,
                feed: feed.fold<List<TransactionModel>>([], (prev, curr) {
                  return prev..addAll(curr);
                }),
                accounts: List<AccountModel>.from(
                  page.accounts.where((e) => e.id != account.id),
                ),
              ),
            );

          // single account page
          case FeedPageStateSingleAccount():
            return Future.value(e);
        }
      }),
    );

    pages.removeAt(pageIndex);

    // remove all accounts page
    if (pages.length == 2) {
      viewModel.removePageScroll(0);
      pages.removeAt(0);
    }

    viewModel.setProtectedState(() => viewModel.pages = pages);
  }
}
