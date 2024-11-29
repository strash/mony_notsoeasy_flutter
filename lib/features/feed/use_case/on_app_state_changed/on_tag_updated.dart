part of "../on_app_state_changed.dart";

final class _OnTagUpdated {
  const _OnTagUpdated();

  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventTagUpdated event,
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
                    e.tags.map((t) => t.id == tag.id ? tag.copyWith() : t),
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
                    e.tags.map((t) => t.id == tag.id ? tag.copyWith() : t),
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
