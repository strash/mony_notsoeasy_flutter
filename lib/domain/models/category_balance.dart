import "package:freezed_annotation/freezed_annotation.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";

part "category_balance.freezed.dart";

@freezed
class CategoryBalanceModel with _$CategoryBalanceModel {
  const factory CategoryBalanceModel({
    required String id,
    required DateTime created,
    required int transactionsCount,
    required double totalSum,
    required DateTime? firstTransactionDate,
    required DateTime? lastTransactionDate,
  }) = _CategoryBalanceModel;
}

extension CategoryBalanceModelEx on CategoryBalanceModel {
  String get transactionsCountDescription {
    final formatter = NumberFormat.decimalPattern();
    final formattedCount = formatter.format(transactionsCount);

    return switch (transactionsCount.wordCaseHint) {
      EWordCaseHint.nominative => "$formattedCount транзакция за все время",
      EWordCaseHint.genitive => "$formattedCount транзакции за все время",
      EWordCaseHint.accusative => "$formattedCount транзакций за все время",
    };
  }

  String get transactionsDateRangeDescription {
    final now = DateTime.now();
    switch ((firstTransactionDate, lastTransactionDate)) {
      case (null, final DateTime rhs):
        final rhsFormatter = DateFormat(
          now.year != rhs.year ? "EEE, dd MMMM yyyy" : "EEE, dd MMMM",
        );
        return rhsFormatter.format(rhs);
      case (final DateTime lhs, null):
        final lhsFormatter = DateFormat(
          now.year != lhs.year ? "EEE, dd MMMM yyyy" : "EEE, dd MMMM",
        );
        return lhsFormatter.format(lhs);
      case (final DateTime lhs, final DateTime rhs):
        String lhsPattern = "dd";
        if (rhs.month != lhs.month) lhsPattern += " MMMM";
        if (now.year != lhs.year && rhs.year != lhs.year) lhsPattern += " yyyy";
        final lhsFormatter = DateFormat(lhsPattern);
        final rhsFormatter = DateFormat(
          now.year != rhs.year ? "dd MMMM yyyy" : "dd MMMM",
        );
        if (lhs.isSameDateAs(rhs)) return rhsFormatter.format(rhs);
        return "${lhsFormatter.format(lhs)}—${rhsFormatter.format(rhs)}";
      default:
        return "";
    }
  }
}
