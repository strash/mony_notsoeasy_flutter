import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:provider/provider.dart";

typedef TOnDataFetchedValue = ({FeedViewModel viewModel, int pageIndex});

final class OnDataFetched extends UseCase<Future<void>, TOnDataFetchedValue> {
  @override
  Future<void> call(BuildContext context, [TOnDataFetchedValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = value.viewModel;
    final currentPage = viewModel.pages.elementAt(value.pageIndex);
    if (!currentPage.canLoadMore) return;

    final page = currentPage.page + 1;
    final transactionService = context.read<DomainTransactionService>();

    switch (currentPage) {
      // -> data for all accounts
      case final FeedPageStateAllAccounts state:
        final data = await transactionService.getMany(page: page);
        final transactions = currentPage.feed.merge(data)
          ..sort((a, b) => b.date.compareTo(a.date));
        viewModel.setProtectedState(() {
          viewModel.pages[value.pageIndex] = state.copyWith(
            page: page,
            feed: transactions,
            canLoadMore: data.isNotEmpty,
          );
        });
      // -> data for an account
      case final FeedPageStateSingleAccount state:
        final data = await transactionService.getMany(
          page: page,
          accountId: state.account.id,
        );
        final transactions = currentPage.feed.merge(data)
          ..sort((a, b) => b.date.compareTo(a.date));
        viewModel.setProtectedState(() {
          viewModel.pages[value.pageIndex] = state.copyWith(
            page: page,
            feed: transactions,
            canLoadMore: data.isNotEmpty,
          );
        });
    }
  }
}
