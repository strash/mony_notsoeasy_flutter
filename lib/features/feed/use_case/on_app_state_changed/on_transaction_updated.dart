part of "../on_app_state_changed.dart";

final class _OnTransactionUpdated {
  const _OnTransactionUpdated();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventTransactionUpdated event,
  ) async {
    final accountSevrice = context.read<DomainAccountService>();

    final transaction = event.value;

    final balances = await accountSevrice.getBalances();

    final pages = viewModel.pages.map((e) {
      switch (e) {
        case final FeedPageStateAllAccounts page:
          return page.copyWith(
            balances: page.balances.merge(balances),
            feed: page.feed.merge([transaction.copyWith()]),
          );
        case final FeedPageStateSingleAccount page:
          return page.copyWith(
            balance: balances.where((e) {
                  return e.id == page.account.id;
                }).firstOrNull ??
                page.balance,
            feed: page.account.id == transaction.account.id
                ? page.feed.merge([transaction.copyWith()])
                : List<TransactionModel>.from(
                    page.feed.where((e) => e.id != transaction.id),
                  ),
          );
      }
    });

    viewModel.setProtectedState(() {
      viewModel.pages = List<FeedPageState>.from(pages);
    });
  }
}
