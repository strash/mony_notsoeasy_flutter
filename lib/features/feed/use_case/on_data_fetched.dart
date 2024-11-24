import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:provider/provider.dart";

final class OnDataFetched extends UseCase<Future<void>, FeedViewModel> {
  @override
  Future<void> call(BuildContext context, [FeedViewModel? viewModel]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final pageIndex = viewModel.currentPageIndex;
    final currentPage = viewModel.pages.elementAt(pageIndex);
    if (!currentPage.canLoadMore) return;

    final scrollPage = currentPage.scrollPage + 1;
    final transactionService = context.read<DomainTransactionService>();

    switch (currentPage) {
      // -> data for all accounts
      case final FeedPageStateAllAccounts page:
        final data = await transactionService.getMany(page: scrollPage);
        viewModel.setProtectedState(() {
          viewModel.pages[pageIndex] = page.copyWith(
            scrollPage: scrollPage,
            feed: page.feed.merge(data),
            canLoadMore: data.isNotEmpty,
          );
        });
      // -> data for an account
      case final FeedPageStateSingleAccount page:
        final data = await transactionService.getMany(
          page: scrollPage,
          accountId: page.account.id,
        );
        viewModel.setProtectedState(() {
          viewModel.pages[pageIndex] = page.copyWith(
            scrollPage: scrollPage,
            feed: page.feed.merge(data),
            canLoadMore: data.isNotEmpty,
          );
        });
    }
  }
}
