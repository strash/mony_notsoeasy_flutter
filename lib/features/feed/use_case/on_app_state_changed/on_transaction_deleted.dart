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

    final balances = await accountSevrice.getBalances(
      ids: [transaction.account.id],
    );

    final pages = viewModel.pages.map((e) {
      switch (e) {
        case final FeedPageStateAllAccounts page:
          return page.copyWith(
            balances: page.balances.merge(balances),
            scrollPage: max(0, page.scrollPage - 1),
            canLoadMore: true,
            feed: List<TransactionModel>.from(
              page.feed.where((e) => e.id != transaction.id),
            ),
          );
        case final FeedPageStateSingleAccount page:
          if (page.account.id == transaction.account.id) {
            return page.copyWith(
              balance: balances.firstOrNull,
              scrollPage: max(0, page.scrollPage - 1),
              canLoadMore: true,
              feed: List<TransactionModel>.from(
                page.feed.where((e) => e.id != transaction.id),
              ),
            );
          }
          return page;
      }
    });

    viewModel.setProtectedState(() {
      viewModel.pages = List<FeedPageState>.from(pages);
    });
  }
}
