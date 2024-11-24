part of "../on_app_state_changed.dart";

final class _OnAccountDeleted {
  const _OnAccountDeleted();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventAccountDeleted event,
  ) async {
    // NOTE: navigator will open start screen in this case
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
          case final FeedPageStateAllAccounts page:
            final balances = await accountSevrice.getBalances();
            final feed = await transactionService.getMany(page: 0);

            return Future.value(
              page.copyWith(
                scrollPage: 0,
                canLoadMore: true,
                feed: feed,
                balances: balances,
                accounts: List<AccountModel>.from(
                  page.accounts.where((e) => e.id != account.id),
                ),
              ),
            );
          case final FeedPageStateSingleAccount page:
            if (page.account.id == account.id) {
              return Future.value(e);
            } else {
              final feed = await transactionService.getMany(
                page: 0,
                accountId: page.account.id,
              );

              return Future.value(
                page.copyWith(scrollPage: 0, canLoadMore: true, feed: feed),
              );
            }
        }
      }),
    );

    pages.removeAt(pageIndex);

    // remove all accounts page
    if (pages.length == 2) {
      viewModel.removePageScroll(0);
      pages.removeAt(0);
    }

    viewModel.setProtectedState(() {
      viewModel.pages = pages;
    });

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      for (final controller in viewModel.scrollControllers) {
        if (!controller.isReady) continue;
        controller.distance = .0;
        controller.jumpTo(0);
      }
    });
  }
}
