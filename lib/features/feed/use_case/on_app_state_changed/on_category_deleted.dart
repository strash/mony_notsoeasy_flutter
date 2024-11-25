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

    final balances = await accountSevrice.getBalances();

    final pages = await Future.wait(
      viewModel.pages.map((e) async {
        switch (e) {
          case final FeedPageStateAllAccounts page:
            final feed = await transactionService.getMany(page: 0);
            return Future.value(
              page.copyWith(
                scrollPage: 0,
                canLoadMore: true,
                feed: feed,
                balances: balances,
              ),
            );
          case final FeedPageStateSingleAccount page:
            final feed = await transactionService.getMany(
              page: 0,
              accountId: page.account.id,
            );
            return Future.value(
              page.copyWith(
                scrollPage: 0,
                canLoadMore: true,
                feed: feed,
                balance: balances.singleWhere((e) => e.id == page.account.id),
              ),
            );
        }
      }),
    );

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
