import "package:freezed_annotation/freezed_annotation.dart";
import "package:sealed_currencies/sealed_currencies.dart";

part "account.freezed.dart";

enum EAccountType {
  debit(value: "debit"),
  credit(value: "credit"),
  cash(value: "cash"),
  savings(value: "savings"),
  investment(value: "investment"),
  ;

  final String value;

  const EAccountType({required this.value});

  static EAccountType get defaultValue => EAccountType.debit;

  static EAccountType from(String type) {
    return EAccountType.values.where((e) => e.value == type).firstOrNull ??
        defaultValue;
  }
}

@freezed
final class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String title,
    required EAccountType type,
    required FiatCurrency currency,
  }) = _AccountModel;
}

extension EAccountTypeEx on EAccountType {
  String get description {
    return switch (this) {
      EAccountType.debit => "Дебетовый счет",
      EAccountType.credit => "Кредитный счет",
      EAccountType.cash => "Наличные",
      EAccountType.savings => "Вклад или накопительный счет",
      EAccountType.investment => "Инвестиционный счет",
    };
  }
}
