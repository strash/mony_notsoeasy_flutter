import "package:flutter/material.dart";
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
      // TODO: при создании второго счета добавлять экран со всеми счетами
      case final EventAccountCreated event:
        final account = event.value;
        final balances = await accountSevrice.getBalances(ids: [account.id]);
        if (balances.isEmpty) return;
        _onAccountCreated(viewModel, balances, account);
      case final EventAccountUpdated event:
        // TODO
        print(event);
      // TODO: при удалении счета, если остался только один, то убирать "все
      // счета"
      case final EventTransactionCreated event:
        final balances = await accountSevrice.getBalances(
          ids: [event.value.account.id],
        );
        _onTransactionCreated(event.value, balances, viewModel);
      case final EventTransactionUpdated event:
        final balances = await accountSevrice.getBalances(
          ids: [event.value.account.id],
        );
        _onTransactionUpdated(event.value, balances, viewModel);
      case final EventTransactionDeleted event:
        final balances = await accountSevrice.getBalances(
          ids: [event.value.account.id],
        );
        _onTransactionDeleted(event.value, balances, viewModel);
    }
  }

  void _onAccountCreated(
    FeedViewModel viewModel,
    List<AccountBalanceModel> balances,
    AccountModel account,
  ) {
    viewModel.addPageScroll(viewModel.pages.length);
    viewModel.setProtectedState(() {
      viewModel.pages = viewModel.pages.map((e) {
        switch (e) {
          case final FeedPageStateAllAccounts page:
            return page.copyWith(balances: _mergeBalances(page, balances));
          case FeedPageStateSingleAccount():
            return e;
        }
      }).toList(growable: true)
        ..add(
          FeedPageStateSingleAccount(
            scrollPage: 0,
            canLoadMore: true,
            feed: const [],
            account: account,
            balance: balances.first,
          ),
        );
    });
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      viewModel.openPage(viewModel.pages.length - 1);
    });
  }

  void _onTransactionCreated(
    TransactionModel transaction,
    List<AccountBalanceModel> balances,
    FeedViewModel viewModel,
  ) {
    viewModel.setProtectedState(() {
      viewModel.pages = viewModel.pages.map((e) {
        switch (e) {
          case final FeedPageStateAllAccounts page:
            return page.copyWith(
              balances: _mergeBalances(page, balances),
              feed: _mergeFeed(page, transaction),
              canLoadMore: true,
            );
          case final FeedPageStateSingleAccount page:
            if (page.account.id == transaction.account.id) {
              return page.copyWith(
                balance: balances.firstOrNull ?? page.balance,
                feed: _mergeFeed(page, transaction),
                canLoadMore: true,
              );
            }
            return page;
        }
      }).toList(growable: false);
    });
  }

  void _onTransactionUpdated(
    TransactionModel transaction,
    List<AccountBalanceModel> balances,
    FeedViewModel viewModel,
  ) {
    viewModel.setProtectedState(() {
      viewModel.pages = viewModel.pages.map((e) {
        switch (e) {
          case final FeedPageStateAllAccounts page:
            return page.copyWith(
              balances: _mergeBalances(page, balances),
              feed: _removeTransaction(page, transaction.id)
                ..add(transaction)
                ..sort((a, b) => b.date.compareTo(a.date)),
            );
          case final FeedPageStateSingleAccount page:
            final feed = _removeTransaction(page, transaction.id);
            if (page.account.id == transaction.account.id) {
              feed.add(transaction);
              feed.sort((a, b) => b.date.compareTo(a.date));
              return page.copyWith(
                balance: balances.firstOrNull ?? page.balance,
                feed: feed,
              );
            }
            return page.copyWith(feed: feed);
        }
      }).toList(growable: false);
    });
  }

  void _onTransactionDeleted(
    TransactionModel transaction,
    List<AccountBalanceModel> balances,
    FeedViewModel viewModel,
  ) {
    viewModel.setProtectedState(() {
      viewModel.pages = viewModel.pages.map((e) {
        switch (e) {
          case final FeedPageStateAllAccounts page:
            return page.copyWith(
              balances: _mergeBalances(page, balances),
              feed: _removeTransaction(page, transaction.id),
            );
          case final FeedPageStateSingleAccount page:
            final feed = _removeTransaction(page, transaction.id);
            if (page.account.id == transaction.account.id) {
              return page.copyWith(
                balance: balances.firstOrNull ?? page.balance,
                feed: feed,
              );
            }
            return page.copyWith(feed: feed);
        }
      }).toList(growable: false);
    });
  }

  List<AccountBalanceModel> _mergeBalances(
    FeedPageStateAllAccounts page,
    List<AccountBalanceModel> balances,
  ) {
    return page.balances.merge(balances)
      ..sort((a, b) => a.created.compareTo(b.created));
  }

  List<TransactionModel> _mergeFeed(
    FeedPageState page,
    TransactionModel transaction,
  ) {
    return page.feed.merge([transaction.copyWith()])
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionModel> _removeTransaction(FeedPageState page, String id) {
    return List<TransactionModel>.from(page.feed.where((e) => e.id != id));
  }
}
