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
class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String title,
    required EAccountType type,
    // TODO: добавить цвет
    required FiatCurrency currency,
    // TODO: добавить изначальную сумму
    // TODO: при создании аккаунта предлагать вбить "сколько сейчас на счету"
    // TODO: если импортить, то высчитывать какая получается сумма после всех
    // транзакций и ее устанавливать как изначальную
    // TODO: при смене аккаунта у транзакции пересчитывать изначальную сумму
    // TODO: при изменении "сколько сейчас на счету" пересчитывать изначальную
    // сумму
    // TODO: перевод с одного счета на другой, что по-сути меняет изначальные
    // суммы на счетах без создания транзакций
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
