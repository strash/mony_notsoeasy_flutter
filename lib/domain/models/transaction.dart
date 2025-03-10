import "package:freezed_annotation/freezed_annotation.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/page/state.dart";
import "package:sealed_currencies/sealed_currencies.dart";

part "transaction.freezed.dart";

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required double amount,
    required DateTime date,
    required String note,
    required AccountModel account,
    required CategoryModel category,
    required List<TagModel> tags,
  }) = _TransactionModel;
}

extension TransactionModelListEx on List<TransactionModel> {
  List<TransactionModel> merge(List<TransactionModel> other) {
    return List<TransactionModel>.from(
        where((e) => !other.any((i) => e.id == i.id)),
      )
      ..addAll(other)
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<FeedItem> toFeed() {
    if (isEmpty) return const [];
    final init = [
      FeedItemSection(date: first.date, total: {}),
      FeedItemTransaction(transaction: first),
    ];
    // transform transactions to the list of transactions and sections
    final feed = foldValue<List<FeedItem>>(init, (prev, curr) {
      final transaction = FeedItemTransaction(transaction: curr);
      if (prev == null) return [];
      if (prev.date.isSameDateAs(curr.date)) return [transaction];
      final section = FeedItemSection(date: curr.date, total: {});
      return <FeedItem>[section, transaction];
    });
    // calculate a day total for each section
    for (final element in feed.indexed) {
      switch (element.$2) {
        case final FeedItemSection section:
          final sectionEntries =
              feed.skip(element.$1 + 1).takeWhile((e) {
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
