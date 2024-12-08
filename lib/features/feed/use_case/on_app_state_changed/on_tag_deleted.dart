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
        // all accounts page
        case final FeedPageStateAllAccounts page:
          return page.copyWith(
            feed: List<TransactionModel>.from(
              page.feed.map(_updateTags(tag)),
            ),
          );

        // single account page
        case final FeedPageStateSingleAccount page:
          return page.copyWith(
            feed: List<TransactionModel>.from(
              page.feed.map(_updateTags(tag)),
            ),
          );
      }
    });

    viewModel.setProtectedState(() {
      viewModel.pages = List<FeedPageState>.from(pages);
    });
  }

  TransactionModel Function(TransactionModel model) _updateTags(TagModel tag) {
    return (e) {
      final tags = e.tags.where((t) => t.id != tag.id);
      return e.copyWith(tags: List<TagModel>.from(tags));
    };
  }
}
