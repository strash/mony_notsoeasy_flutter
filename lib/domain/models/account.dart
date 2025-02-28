import "package:freezed_annotation/freezed_annotation.dart";
import "package:mony_app/app/app.dart";
import "package:sealed_currencies/sealed_currencies.dart";

part "account.freezed.dart";

enum EAccountType implements IDescriptable {
  debit(value: "debit"),
  credit(value: "credit"),
  cash(value: "cash"),
  savings(value: "savings"),
  investment(value: "investment");

  final String value;

  const EAccountType({required this.value});

  static EAccountType get defaultValue => EAccountType.debit;

  static EAccountType from(String type) {
    return EAccountType.values.where((e) => e.value == type).firstOrNull ??
        defaultValue;
  }

  @override
  String get description {
    return switch (this) {
      EAccountType.debit => "Дебетовый счет",
      EAccountType.credit => "Кредитный счет",
      EAccountType.cash => "Наличные",
      EAccountType.savings => "Вклад, накопительный счет",
      EAccountType.investment => "Инвестиционный счет",
    };
  }

  String get icon {
    return switch (this) {
      EAccountType.debit => "💳",
      EAccountType.credit => "🛟",
      EAccountType.cash => "💵",
      EAccountType.savings => "🐷",
      EAccountType.investment => "🦄",
    };
  }
}

@freezed
abstract class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String title,
    required EAccountType type,
    required FiatCurrency currency,
    required EColorName colorName,
    required double balance,
  }) = _AccountModel;
}

extension AccountModelEx on List<AccountModel> {
  List<AccountModel> merge(List<AccountModel> other) {
    return List<AccountModel>.from(
        where((e) => !other.any((i) => e.id == i.id)),
      )
      ..addAll(other)
      ..sort((a, b) => a.created.compareTo(b.created));
  }
}
