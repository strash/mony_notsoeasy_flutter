import "package:mony_app/domain/models/models.dart";

final class AccountVO {
  final String title;
  final EAccountType type;
  final String currencyCode;
  final String colorName;
  final double balance;

  const AccountVO({
    required this.title,
    required this.type,
    required this.currencyCode,
    required this.colorName,
    required this.balance,
  });
}

sealed class AccountVariant {}

final class AccountVariantVO extends AccountVariant {
  final AccountVO vo;
  AccountVariantVO({required this.vo});
}

final class AccountVariantModel extends AccountVariant {
  final AccountModel model;
  AccountVariantModel({required this.model});
}
