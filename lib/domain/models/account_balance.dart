import "package:freezed_annotation/freezed_annotation.dart";
import "package:sealed_currencies/sealed_currencies.dart";

part "account_balance.freezed.dart";

@freezed
class AccountBalanceModel with _$AccountBalanceModel {
  const factory AccountBalanceModel({
    required String id,
    required DateTime created,
    required FiatCurrency currency,
    required double balance,
    required double totalAmount,
    required double expenseAmount,
    required double incomeAmount,
    required int totalCount,
    required int expenseCount,
    required int incomeCount,
    required DateTime? firstTransactionDate,
    required DateTime? lastTransactionDate,
  }) = _AccountBalanceModel;
}

extension AccountBalanceModelEx on AccountBalanceModel {
  double get totalSum {
    return balance + totalAmount;
  }
}

extension AccountBalanceModelListEx on List<AccountBalanceModel> {
  List<AccountBalanceModel> merge(List<AccountBalanceModel> other) {
    return List<AccountBalanceModel>.from(
        where((e) => !other.any((i) => e.id == i.id)),
      )
      ..addAll(other)
      ..sort((a, b) => a.created.compareTo(b.created));
  }

  List<AccountBalanceModel> foldByCurrency() {
    final Map<String, AccountBalanceModel> map = {};
    for (final element in this) {
      final name = element.currency.name;
      final item = map[name];
      map[name] =
          item?.copyWith(
            balance: item.balance + element.balance,
            totalAmount: item.totalAmount + element.totalAmount,
          ) ??
          element;
    }
    return map.entries.map((e) => e.value).toList(growable: false);
  }
}
