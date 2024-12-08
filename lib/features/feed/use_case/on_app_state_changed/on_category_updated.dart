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
        // all accounts page
        case final FeedPageStateAllAccounts page:
          return page.copyWith(
            feed: List<TransactionModel>.from(
              page.feed.map(_updateCategories(category)),
            ),
          );

        // single account page
        case final FeedPageStateSingleAccount page:
          return page.copyWith(
            feed: List<TransactionModel>.from(
              page.feed.map(_updateCategories(category)),
            ),
          );
      }
    });

    viewModel.setProtectedState(() {
      viewModel.pages = List<FeedPageState>.from(pages);
    });
  }

  TransactionModel Function(TransactionModel) _updateCategories(
    CategoryModel category,
  ) {
    return (TransactionModel e) {
      if (e.category.id != category.id) return e;
      return e.copyWith(category: category.copyWith());
    };
  }
}
