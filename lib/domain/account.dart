import "package:freezed_annotation/freezed_annotation.dart";

part "account.freezed.dart";

enum AccountType { cash, debit, credit, savings, investment }

@freezed
final class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String title,
    required AccountType type,
  }) = _AccountModel;
}

extension AccountTypeEx on AccountType {
  static AccountType get defaultValue => AccountType.debit;

  static AccountType from(String type) {
    return AccountType.values.where((e) => e.name == type).firstOrNull ??
        defaultValue;
  }

  // NOTE: на случай, если вдруг переименую енумы эти константы для db
  // остануться
  String get toName {
    return switch (this) {
      AccountType.cash => "cash",
      AccountType.debit => "debit",
      AccountType.credit => "credit",
      AccountType.savings => "savings",
      AccountType.investment => "investment",
    };
  }

  String get description {
    return switch (this) {
      AccountType.cash => "Наличные",
      AccountType.debit => "Дебетовый счет",
      AccountType.credit => "Кредитный счет",
      AccountType.savings => "Вклад или накопительный счет",
      AccountType.investment => "Инвестиционный счет",
    };
  }
}
