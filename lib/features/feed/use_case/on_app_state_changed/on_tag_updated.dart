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
        // all accounts page
        case final FeedPageStateAllAccounts page:
          return page.copyWith(
            feed: List<TransactionModel>.from(page.feed.map(_updateTags(tag))),
          );

        // single account page
        case final FeedPageStateSingleAccount page:
          return page.copyWith(
            feed: List<TransactionModel>.from(page.feed.map(_updateTags(tag))),
          );
      }
    });

    viewModel.setProtectedState(() {
      viewModel.pages = List<FeedPageState>.from(pages);
    });
  }

  TransactionModel Function(TransactionModel model) _updateTags(TagModel tag) {
    return (e) {
      final tags = e.tags.map((t) => t.id == tag.id ? tag.copyWith() : t);
      return e.copyWith(tags: List<TagModel>.from(tags));
    };
  }
}
