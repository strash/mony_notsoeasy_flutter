part of "../on_app_state_changed.dart";

final class _OnTransactionUpdated {
  const _OnTransactionUpdated();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventTransactionUpdated event,
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

            return Future.value(
              page.copyWith(
                balances: balances,
                feed: page.feed.merge([transaction.copyWith()]),
              ),
            );

          // single account page
          case final FeedPageStateSingleAccount page:
            final balance = await accountSevrice.getBalance(
              id: page.account.id,
            );
            // NOTE: transaction can change an account, so we just update them
            // all at once
            final feed = await Future.wait<List<TransactionModel>>(
              List.generate(page.scrollPage + 1, (index) {
                return transactionService.getMany(
                  page: index,
                  accountIds: [page.account.id],
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
