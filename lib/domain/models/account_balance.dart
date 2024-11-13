import "package:freezed_annotation/freezed_annotation.dart";
import "package:sealed_currencies/sealed_currencies.dart";

part "account_balance.freezed.dart";

@freezed
class AccountBalanceModel with _$AccountBalanceModel {
  const factory AccountBalanceModel({
    required String id,
    required FiatCurrency currency,
    required double balance,
    required double totalAmount,
    required double totalSum,
    required DateTime created,
  }) = _AccountBalanceModel;
}

extension AccountBalanceModelListEx on List<AccountBalanceModel> {
  List<AccountBalanceModel> merge(List<AccountBalanceModel> other) {
    return List<AccountBalanceModel>.from(
      where((e) => !other.any((i) => e.id == i.id)),
    )..addAll(other);
  }

  List<AccountBalanceModel> foldByCurrency() {
    final Map<String, AccountBalanceModel> map = {};
    for (final element in this) {
      final name = element.currency.name;
      map[name] = map[name]?.copyWith(
            balance: (map[name]?.balance ?? .0) + element.balance,
            totalAmount: (map[name]?.totalAmount ?? .0) + element.totalAmount,
            totalSum: (map[name]?.totalSum ?? .0) + element.totalSum,
          ) ??
          element;
    }
    return map.entries.map((e) => e.value).toList(growable: false);
  }
}
