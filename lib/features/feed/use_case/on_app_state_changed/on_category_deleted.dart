part of "../on_app_state_changed.dart";

final class _OnCategoryDeleted {
  const _OnCategoryDeleted();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventCategoryDeleted event,
  ) async {
    final accountSevrice = context.service<DomainAccountService>();
    final transactionService = context.service<DomainTransactionService>();

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
              ),
            );

          // single account page
          case final FeedPageStateSingleAccount page:
            final id = page.account.id;
            final balance = await accountSevrice.getBalance(id: id);
            final List<List<TransactionModel>> feed = [];
            int scrollPage = 0;
            do {
              feed.add(
                await transactionService.getMany(
                  page: scrollPage++,
                  accountIds: [id],
                ),
              );
            } while (scrollPage <= page.scrollPage &&
                (feed.lastOrNull?.isNotEmpty ?? false));

            return Future.value(
              page.copyWith(
                balance: balance,
                scrollPage: scrollPage,
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
