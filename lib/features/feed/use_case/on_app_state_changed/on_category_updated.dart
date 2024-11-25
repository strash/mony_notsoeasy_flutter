part of "../on_app_state_changed.dart";

final class _OnCategoryUpdated {
  const _OnCategoryUpdated();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventCategoryUpdated event,
  ) async {
    final category = event.value;

    final pages = viewModel.pages.map((e) {
      switch (e) {
        case final FeedPageStateAllAccounts page:
          return page.copyWith(
            feed: List<TransactionModel>.from(
              page.feed.map((transaction) {
                if (transaction.category.id != category.id) return transaction;
                return transaction.copyWith(category: category.copyWith());
              }),
            ),
          );
        case final FeedPageStateSingleAccount page:
          return page.copyWith(
            feed: List<TransactionModel>.from(
              page.feed.map((transaction) {
                if (transaction.category.id != category.id) return transaction;
                return transaction.copyWith(category: category.copyWith());
              }),
            ),
          );
      }
    });

    viewModel.setProtectedState(() {
      viewModel.pages = List<FeedPageState>.from(pages);
    });
  }
}
