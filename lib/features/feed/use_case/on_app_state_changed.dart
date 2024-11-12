import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/feed/page/page.dart";

typedef TOnAppStateChangedValue = ({FeedViewModel viewModel, Event event});

final class OnAppStateChanged extends UseCase<void, TOnAppStateChangedValue>
    with DataFetchMixin {
  @override
  void call(BuildContext context, [TOnAppStateChangedValue? value]) {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    switch (event) {
      case final EventAccountCreated event:
        // TODO: Handle this case.
        final account = event.account;

      case final EventTransactionCreated event:
        final transaction = event.transaction;

        List<FeedItem> feed(List<FeedItem> transactions) {
          return transformToFeed(
            transformToTransactions(transactions)
                .merge([transaction.copyWith()])
              ..sort((a, b) => b.date.compareTo(a.date)),
          );
        }

        value.viewModel.setProtectedState(() {
          viewModel.pages = viewModel.pages.map((e) {
            switch (e) {
              case final FeedPageStateAllAccounts page:
                return page.copyWith(feed: feed(page.feed));
              case final FeedPageStateSingleAccount page:
                if (page.account.id == transaction.account.id) {
                  return page.copyWith(feed: feed(page.feed));
                }
                return page;
            }
          }).toList(growable: false);
        });
    }
  }
}
