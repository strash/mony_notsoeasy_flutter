import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/services/transaction.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:provider/provider.dart";

typedef TOnDataFetchedValue = ({FeedViewModel viewModel, int pageIndex});

final class OnDataFetched extends UseCase<Future<void>, TOnDataFetchedValue>
    with DataFetchMixin {
  @override
  Future<void> call(BuildContext context, [TOnDataFetchedValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final transactionService = context.read<DomainTransactionService>();

    final viewModel = value.viewModel;
    final currentPage = viewModel.pages.elementAt(value.pageIndex);
    if (!currentPage.canLoadMore) return;
    final pageIndex = currentPage.page + 1;
    final data = await transactionService.getMany(page: pageIndex);
    final transactions = transformToTransactions(currentPage.feed)
      ..addAll(data)
      ..sort((a, b) => b.date.compareTo(a.date));

    switch (viewModel.pages.elementAt(value.pageIndex)) {
      case final FeedPageStateAllAccounts page:
        viewModel.setProtectedState(() {
          viewModel.pages[value.pageIndex] = page.copyWith(
            page: pageIndex,
            canLoadMore: data.isNotEmpty,
            feed: transformToFeed(transactions),
          );
        });
      case final FeedPageStateSingleAccount page:
        viewModel.setProtectedState(() {
          viewModel.pages[value.pageIndex] = page.copyWith(
            page: pageIndex,
            canLoadMore: data.isNotEmpty,
            feed: transformToFeed(transactions),
          );
        });
    }
  }
}
