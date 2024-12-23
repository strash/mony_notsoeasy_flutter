part of "../on_app_state_changed.dart";

final class _OnCategoryDeleted {
  const _OnCategoryDeleted();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventCategoryDeleted event,
  ) async {
    final accountSevrice = context.read<DomainAccountService>();
    final transactionService = context.read<DomainTransactionService>();

    final pages = await Future.wait(
      viewModel.pages.map((e) async {
        switch (e) {
          // all accounts page
          case final FeedPageStateAllAccounts page:
            final balances = await accountSevrice.getBalances();
            final feed = await transactionService.getMany(page: 0);

            return Future.value(
              page.copyWith(
                scrollPage: 1,
                canLoadMore: feed.isNotEmpty,
                feed: feed,
                balances: balances,
              ),
            );

          // single account page
          case final FeedPageStateSingleAccount page:
            final balance = await accountSevrice.getBalance(
              id: page.account.id,
            );
            final feed = await transactionService.getMany(
              page: 0,
              accountIds: [page.account.id],
            );

            return Future.value(
              page.copyWith(
                scrollPage: 1,
                canLoadMore: feed.isNotEmpty,
                feed: feed,
                balance: balance,
              ),
            );
        }
      }),
    );

    viewModel.setProtectedState(() => viewModel.pages = pages);

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      for (final controller in viewModel.scrollControllers) {
        if (!controller.isReady) continue;
        controller.distance = .0;
        controller.jumpTo(0);
      }
    });
  }
}
