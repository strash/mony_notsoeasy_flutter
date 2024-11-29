part of "../on_app_state_changed.dart";

final class _OnTagDeleted {
  const _OnTagDeleted();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventTagDeleted event,
  ) async {
    final tag = event.value;

    final pages = viewModel.pages.map((e) {
      switch (e) {
        case final FeedPageStateAllAccounts page:
          return page.copyWith(
            feed: List<TransactionModel>.from(
              page.feed.map((e) {
                return e.copyWith(
                  tags: List<TagModel>.from(
                    e.tags.where((t) => t.id != tag.id),
                  ),
                );
              }),
            ),
          );
        case final FeedPageStateSingleAccount page:
          return page.copyWith(
            feed: List<TransactionModel>.from(
              page.feed.map((e) {
                return e.copyWith(
                  tags: List<TagModel>.from(
                    e.tags.where((t) => t.id != tag.id),
                  ),
                );
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
