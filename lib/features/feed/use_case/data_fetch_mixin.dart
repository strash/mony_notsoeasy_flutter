import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:sealed_currencies/sealed_currencies.dart";

mixin DataFetchMixin {
  List<TransactionModel> transformToTransactions(List<FeedItem> feed) {
    return feed
        .whereType<FeedItemTransaction>()
        .map<TransactionModel>((e) => e.transaction)
        .toList(growable: true);
  }

  List<FeedItem> transformToFeed(List<TransactionModel> transactions) {
    if (transactions.isEmpty) return const [];
    final first = transactions.first;
    final init = [
      FeedItemSection(date: first.date, total: {}),
      FeedItemTransaction(transaction: first),
    ];
    // transform transactions to the list of transactions and sections
    final feed = transactions.foldValue<List<FeedItem>>(init, (prev, curr) {
      final transaction = FeedItemTransaction(transaction: curr);
      if (prev.date.isSameDateAs(curr.date)) return [transaction];
      final section = FeedItemSection(date: curr.date, total: {});
      return <FeedItem>[section, transaction];
    });
    // calculate a day total for each section
    for (final element in feed.indexed) {
      switch (element.$2) {
        case final FeedItemSection section:
          final sectionEntries = feed.skip(element.$1 + 1).takeWhile((e) {
            return e is FeedItemTransaction;
          }).cast<FeedItemTransaction>();
          final Map<FiatCurrency, double> total = {};
          for (final FeedItemTransaction item in sectionEntries) {
            final cur = item.transaction.account.currency;
            final value = total[cur] ?? .0;
            total[cur] = value + item.transaction.amount;
          }
          feed[element.$1] = section.copyWith(total: total);
        case FeedItemTransaction():
          continue;
      }
    }
    return feed;
  }
}
