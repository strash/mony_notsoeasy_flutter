import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/page/page.dart";
import "package:provider/provider.dart";

typedef TOnAppStateChangedValue = ({FeedViewModel viewModel, Event event});

final class OnAppStateChanged
    extends UseCase<Future<void>, TOnAppStateChangedValue> {
  @override
  Future<void> call(
    BuildContext context, [
    TOnAppStateChangedValue? value,
  ]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final accountSevrice = context.read<DomainAccountService>();

    switch (event) {
      case final EventAccountCreated event:
        // TODO: Handle this case.
        final account = event.account;

      case final EventTransactionCreated event:
        final transaction = event.transaction;
        final balances = await accountSevrice.getBalance(
          ids: [transaction.account.id],
        );

        viewModel.setProtectedState(() {
          viewModel.pages = viewModel.pages.map((e) {
            switch (e) {
              case final FeedPageStateAllAccounts page:
                return page.copyWith(
                  balances: page.balances.merge(balances)
                    ..sort((a, b) => a.created.compareTo(b.created)),
                  feed: page.feed.merge([transaction.copyWith()])
                    ..sort((a, b) => b.date.compareTo(a.date)),
                  canLoadMore: true,
                );
              case final FeedPageStateSingleAccount page:
                if (page.account.id == transaction.account.id) {
                  return page.copyWith(
                    balance: balances.firstOrNull ?? page.balance,
                    feed: page.feed.merge([transaction.copyWith()])
                      ..sort((a, b) => b.date.compareTo(a.date)),
                    canLoadMore: true,
                  );
                }
                return page;
            }
          }).toList(growable: false);
        });
      case final EventTransactionUpdated event:
        final transaction = event.transaction.copyWith();
        final balances = await accountSevrice.getBalance(
          ids: [transaction.account.id],
        );

        viewModel.setProtectedState(() {
          viewModel.pages = viewModel.pages.map((e) {
            switch (e) {
              case final FeedPageStateAllAccounts page:
                return page.copyWith(
                  balances: page.balances.merge(balances)
                    ..sort((a, b) => a.created.compareTo(b.created)),
                  feed: List<TransactionModel>.from(
                    page.feed.where((e) => e.id != transaction.id),
                  )
                    ..add(transaction)
                    ..sort((a, b) => b.date.compareTo(a.date)),
                );
              case final FeedPageStateSingleAccount page:
                final feed = List<TransactionModel>.from(
                  page.feed.where((e) => e.id != transaction.id),
                );
                if (page.account.id == transaction.account.id) {
                  feed.add(transaction);
                  feed.sort((a, b) => b.date.compareTo(a.date));
                }
                return page.copyWith(
                  feed: feed,
                  balance: balances.firstOrNull ?? page.balance,
                );
            }
          }).toList(growable: false);
        });
    }
  }
}
