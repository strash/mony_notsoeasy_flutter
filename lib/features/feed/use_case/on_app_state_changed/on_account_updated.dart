part of "../on_app_state_changed.dart";

final class _OnAccountUpdated {
  const _OnAccountUpdated();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventAccountUpdated event,
  ) async {
    final accountSevrice = context.read<DomainAccountService>();
    final transactionService = context.read<DomainTransactionService>();

    final account = event.value;

    final pages = await Future.wait(
      viewModel.pages.map((e) async {
        switch (e) {
          case final FeedPageStateAllAccounts page:
            final feed = await Future.wait(
              List.generate(page.scrollPage + 1, (index) {
                return transactionService.getMany(page: index);
              }),
            );
            final balances = await accountSevrice.getBalances();

            return Future.value(
              page.copyWith(
                canLoadMore: true,
                feed: feed.fold<List<TransactionModel>>([], (prev, curr) {
                  return [...prev, ...curr];
                }),
                balances: page.balances.merge(balances),
                accounts: page.accounts.merge([account.copyWith()]),
              ),
            );
          case final FeedPageStateSingleAccount page:
            if (page.account.id == account.id) {
              final feed = await Future.wait(
                List.generate(page.scrollPage + 1, (index) {
                  return transactionService.getMany(
                    page: index,
                    accountId: account.id,
                  );
                }),
              );
              final balances = await accountSevrice.getBalances(
                ids: [account.id],
              );

              return Future.value(
                page.copyWith(
                  canLoadMore: true,
                  feed: feed.fold<List<TransactionModel>>([], (prev, curr) {
                    return [...prev, ...curr];
                  }),
                  balance: balances.firstOrNull,
                  account: account.copyWith(),
                ),
              );
            }
            return Future.value(page);
        }
      }),
    );

    viewModel.setProtectedState(() {
      viewModel.pages = pages;
    });

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      for (final (index, controller) in viewModel.scrollControllers.indexed) {
        if (!controller.isReady) continue;
        controller.jumpTo(viewModel.scrollPositions.elementAt(index));
      }
    });
  }
}