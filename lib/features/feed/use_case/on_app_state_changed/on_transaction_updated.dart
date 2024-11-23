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

    final balances = await accountSevrice.getBalances(
      ids: [transaction.account.id],
    );

    final pages = viewModel.pages.map((e) {
      switch (e) {
        case final FeedPageStateAllAccounts page:
          return page.copyWith(
            balances: page.balances.merge(balances),
            feed: page.feed.merge([transaction.copyWith()]),
          );
        case final FeedPageStateSingleAccount page:
          if (page.account.id == transaction.account.id) {
            return page.copyWith(
              balance: balances.firstOrNull ?? page.balance,
              feed: page.feed.merge([transaction.copyWith()]),
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
