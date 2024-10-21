import "dart:ui";

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

// TODO: если импортить, то высчитывать какая получается сумма после всех
// транзакций и ее устанавливать как изначальную
// TODO: при изменении "сколько сейчас на счету" пересчитывать изначальную сумму
// TODO: при смене аккаунта у транзакции пересчитывать изначальную сумму
// TODO: перевод с одного счета на другой, что по-сути меняет изначальные суммы
// на счетах без создания транзакций
@freezed
class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String title,
    required EAccountType type,
    required FiatCurrency currency,
    required Color color,
    required double balance,
  }) = _AccountModel;
}

extension EAccountTypeEx on EAccountType {
  String get description {
    return switch (this) {
      EAccountType.debit => "Дебетовый счет",
      EAccountType.credit => "Кредитный счет",
      EAccountType.cash => "Наличные",
      EAccountType.savings => "Вклад, накопительный счет",
      EAccountType.investment => "Инвестиционный счет",
    };
  }
}
