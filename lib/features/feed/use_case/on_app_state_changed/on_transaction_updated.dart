part of "../on_app_state_changed.dart";

final class _OnTransactionUpdated {
  const _OnTransactionUpdated();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventTransactionUpdated event,
  ) async {
    final accountSevrice = context.read<DomainAccountService>();
    final transactionService = context.read<DomainTransactionService>();

    final transaction = event.value;

    final pages = await Future.wait(
      viewModel.pages.map((e) async {
        switch (e) {
          case final FeedPageStateAllAccounts page:
            return Future.value(
              page.copyWith(
                balances: await accountSevrice.getBalances(),
                feed: page.feed.merge([transaction.copyWith()]),
              ),
            );
          case final FeedPageStateSingleAccount page:
            return Future.value(
              page.copyWith(
                balance: await accountSevrice.getBalance(id: page.account.id),
                feed: page.account.id == transaction.account.id
                    ? page.feed.merge([transaction.copyWith()])
                    : (await Future.wait<List<TransactionModel>>(
                        List.generate(page.scrollPage + 1, (index) {
                          return transactionService.getMany(
                            page: index,
                            accountIds: [page.account.id],
                          );
                        }),
                      ))
                        .foldValue([], (prev, next) {
                        return [...prev ?? [], ...next];
                      }),
              ),
            );
        }
      }),
    );

    viewModel.setProtectedState(() {
      viewModel.pages = List<FeedPageState>.from(pages);
    });
  }
}
