import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/page/page.dart";
import "package:provider/provider.dart";

typedef TOnAppStateChangedValue = ({FeedViewModel viewModel, Event event});

final class OnAppStateChanged
    extends UseCase<Future<void>, TOnAppStateChangedValue> {
  List<TransactionModel> _addTransaction(
    TransactionModel transaction,
    List<TransactionModel> transactions,
  ) {
    return transactions.merge([transaction.copyWith()])
      ..sort((a, b) => b.date.compareTo(a.date));
  }

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
          ids: [event.transaction.account.id],
        );

        value.viewModel.setProtectedState(() {
          viewModel.pages = viewModel.pages.map((e) {
            switch (e) {
              case final FeedPageStateAllAccounts page:
                return page.copyWith(
                  feed: _addTransaction(transaction, page.feed),
                  balances: page.balances.merge(balances),
                  canLoadMore: true,
                );
              case final FeedPageStateSingleAccount page:
                if (page.account.id == transaction.account.id) {
                  return page.copyWith(
                    feed: _addTransaction(transaction, page.feed),
                    balance: balances.firstOrNull ?? page.balance,
                    canLoadMore: true,
                  );
                }
                return page;
            }
          }).toList(growable: false);
        });
    }
  }
}
