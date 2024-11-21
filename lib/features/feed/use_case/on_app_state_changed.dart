import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/scroll_controller.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/page/page.dart";
import "package:provider/provider.dart";

typedef _TValue = ({FeedViewModel viewModel, Event event});

final class OnFeedAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(
    BuildContext context, [
    _TValue? value,
  ]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final accountSevrice = context.read<DomainAccountService>();
    final transactionService = context.read<DomainTransactionService>();

    switch (event) {
      case EventAccountCreated(value: final account):
        final balances = await accountSevrice.getBalances();
        final transactions = await transactionService.getMany(page: 0);
        _onAccountCreated(viewModel, balances, account, transactions);
      case EventAccountUpdated(value: final account):
        final balances = await accountSevrice.getBalances(ids: [account.id]);
        if (balances.isEmpty) return;
        final allTransactions = await transactionService.getMany(page: 0);
        final accTransactions =
            await transactionService.getMany(page: 0, accountId: account.id);
        _onAccountUpdated(
          viewModel,
          balances.first,
          account,
          allTransactions,
          accTransactions,
        );
      case EventAccountDeleted(value: final account):
        if (viewModel.pages.length == 1) return;
        final balances = await accountSevrice.getBalances();
        final transactions = await transactionService.getMany(page: 0);
        _onAccountDeleted(viewModel, transactions, balances, account);
      case EventTransactionCreated(value: final transaction):
        final balances = await accountSevrice.getBalances(
          ids: [transaction.account.id],
        );
        _onTransactionCreated(transaction, balances, viewModel);
      case EventTransactionUpdated(value: final transaction):
        final balances = await accountSevrice.getBalances(
          ids: [transaction.account.id],
        );
        _onTransactionUpdated(transaction, balances, viewModel);
      case EventTransactionDeleted(value: final transaction):
        final balances = await accountSevrice.getBalances(
          ids: [transaction.account.id],
        );
        _onTransactionDeleted(transaction, balances, viewModel);
    }
  }

  void _onAccountCreated(
    FeedViewModel viewModel,
    List<AccountBalanceModel> balances,
    AccountModel account,
    List<TransactionModel> transactions,
  ) {
    viewModel.addPageScroll(viewModel.pages.length);
    viewModel.setProtectedState(() {
      final pages = List<FeedPageState>.from(
        viewModel.pages.map((e) {
          switch (e) {
            case final FeedPageStateAllAccounts page:
              return page.copyWith(balances: _mergeBalances(page, balances));
            case FeedPageStateSingleAccount():
              return e;
          }
        }),
      )..add(
          FeedPageStateSingleAccount(
            scrollPage: 0,
            canLoadMore: true,
            feed: const [],
            account: account.copyWith(),
            balance: balances.where((e) => e.id == account.id).first,
          ),
        );
      if (pages.whereType<FeedPageStateAllAccounts>().isEmpty) {
        viewModel.addPageScroll(0);
        pages.insert(
          0,
          FeedPageStateAllAccounts(
            scrollPage: 1,
            canLoadMore: true,
            feed: transactions,
            accounts: List<AccountModel>.from(
              viewModel.pages
                  .whereType<FeedPageStateSingleAccount>()
                  .map((e) => e.account),
            )..add(account.copyWith()),
            balances: balances,
          ),
        );
      }
      viewModel.pages = pages;
    });
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      viewModel.openPage(viewModel.pages.length - 1);
    });
  }

  void _onAccountUpdated(
    FeedViewModel viewModel,
    AccountBalanceModel? balance,
    AccountModel account,
    List<TransactionModel> allTransactions,
    List<TransactionModel> accountTransactions,
  ) {
    viewModel.setProtectedState(() {
      viewModel.pages = List<FeedPageState>.from(
        viewModel.pages.map((e) {
          switch (e) {
            case final FeedPageStateAllAccounts page:
              return page.copyWith(
                scrollPage: 1,
                canLoadMore: true,
                feed: allTransactions,
                balances: balance != null
                    ? _mergeBalances(page, [balance])
                    : page.balances,
                accounts: List<AccountModel>.from(
                  page.accounts.where((e) => e.id != account.id),
                )..add(account.copyWith()),
              );
            case final FeedPageStateSingleAccount page:
              if (page.account.id == account.id) {
                return page.copyWith(
                  scrollPage: 1,
                  canLoadMore: true,
                  feed: accountTransactions,
                  balance: balance,
                  account: account.copyWith(),
                );
              }
              return page;
          }
        }),
      );
    });
  }

  void _onAccountDeleted(
    FeedViewModel viewModel,
    List<TransactionModel> transactions,
    List<AccountBalanceModel> balances,
    AccountModel account,
  ) {
    final pageIndex = viewModel.pages.indexWhere((e) {
      return e is FeedPageStateSingleAccount && e.account.id == account.id;
    });
    viewModel.setProtectedState(() {
      viewModel.removePageScroll(pageIndex);
      viewModel.pages = List<FeedPageState>.from(viewModel.pages)
        ..removeAt(pageIndex);
      if (viewModel.pages.length == 2) {
        // remove all accounts page
        viewModel.removePageScroll(0);
        viewModel.pages = List<FeedPageState>.from(viewModel.pages)
          ..removeAt(0);
      } else {
        viewModel.pages = List<FeedPageState>.from(
          viewModel.pages.map((e) {
            switch (e) {
              case final FeedPageStateAllAccounts page:
                return page.copyWith(
                  scrollPage: 0,
                  canLoadMore: true,
                  feed: transactions,
                  balances: balances,
                  accounts: List<AccountModel>.from(
                    page.accounts.where((e) => e.id != account.id),
                  ),
                );
              case final FeedPageStateSingleAccount page:
                return page;
            }
          }),
        );
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final currentPage = viewModel.currentPageIndex;
      final scroll = viewModel.scrollControllers.elementAt(currentPage);
      if (!scroll.isReady) return;
      scroll.jumpTo(viewModel.scrollPositions.elementAt(currentPage));
    });
  }

  void _onTransactionCreated(
    TransactionModel transaction,
    List<AccountBalanceModel> balances,
    FeedViewModel viewModel,
  ) {
    viewModel.setProtectedState(() {
      viewModel.pages = List<FeedPageState>.from(
        viewModel.pages.map((e) {
          switch (e) {
            case final FeedPageStateAllAccounts page:
              return page.copyWith(
                balances: _mergeBalances(page, balances),
                feed: _mergeFeed(page, transaction.copyWith()),
                canLoadMore: true,
              );
            case final FeedPageStateSingleAccount page:
              if (page.account.id == transaction.account.id) {
                return page.copyWith(
                  balance: balances.firstOrNull,
                  feed: _mergeFeed(page, transaction.copyWith()),
                  canLoadMore: true,
                );
              }
              return page;
          }
        }),
      );
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
              feed: List<TransactionModel>.from(
                page.feed.where((e) => e.id != transaction.id),
              )
                ..add(transaction.copyWith())
                ..sort((a, b) => b.date.compareTo(a.date)),
            );
          case final FeedPageStateSingleAccount page:
            final feed = List<TransactionModel>.from(
              page.feed.where((e) => e.id != transaction.id),
            );
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
              feed: List<TransactionModel>.from(
                page.feed.where((e) => e.id != transaction.id),
              ),
            );
          case final FeedPageStateSingleAccount page:
            final feed = List<TransactionModel>.from(
              page.feed.where((e) => e.id != transaction.id),
            );
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
}
