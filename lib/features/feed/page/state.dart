import "package:mony_app/domain/models/models.dart";
import "package:sealed_currencies/sealed_currencies.dart";

// -> feed item variants

sealed class FeedItem {}

final class FeedItemSection extends FeedItem {
  final DateTime date;
  final Map<FiatCurrency, double> total;

  FeedItemSection({required this.date, required this.total});

  FeedItemSection copyWith({DateTime? date, Map<FiatCurrency, double>? total}) {
    return FeedItemSection(date: date ?? this.date, total: total ?? this.total);
  }
}

final class FeedItemTransaction extends FeedItem {
  final TransactionModel transaction;

  FeedItemTransaction({required this.transaction});
}

// -> page item by account

sealed class FeedPageState {
  final int page;
  final bool canLoadMore;
  final List<FeedItem> feed;

  FeedPageState({
    required this.page,
    required this.canLoadMore,
    required this.feed,
  });
}

final class FeedPageStateAllAccounts extends FeedPageState {
  final List<AccountModel> accounts;

  FeedPageStateAllAccounts({
    required super.page,
    required super.canLoadMore,
    required super.feed,
    required this.accounts,
  });

  FeedPageStateAllAccounts copyWith({
    int? page,
    bool? canLoadMore,
    double? scrollPosition,
    List<FeedItem>? feed,
    List<AccountModel>? accounts,
  }) {
    return FeedPageStateAllAccounts(
      page: page ?? this.page,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      feed: feed ?? this.feed,
      accounts: accounts ?? this.accounts,
    );
  }
}

final class FeedPageStateSingleAccount extends FeedPageState {
  final AccountModel account;

  FeedPageStateSingleAccount({
    required super.page,
    required super.canLoadMore,
    required super.feed,
    required this.account,
  });

  FeedPageStateSingleAccount copyWith({
    int? page,
    bool? canLoadMore,
    double? scrollPosition,
    List<FeedItem>? feed,
    AccountModel? account,
  }) {
    return FeedPageStateSingleAccount(
      page: page ?? this.page,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      feed: feed ?? this.feed,
      account: account ?? this.account,
    );
  }
}
