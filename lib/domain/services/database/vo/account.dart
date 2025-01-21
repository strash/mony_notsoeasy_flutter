import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/models/models.dart";

final class AccountVO {
  final String? id;
  final DateTime? created;
  final DateTime? updated;
  final String title;
  final EAccountType type;
  final String currencyCode;
  final String colorName;
  final double balance;

  const AccountVO({
    this.id,
    this.created,
    this.updated,
    required this.title,
    required this.type,
    required this.currencyCode,
    required this.colorName,
    required this.balance,
  });

  static AccountVO? from(Map<String, dynamic> map) {
    final String? id = map["id"] as String?;
    final String? created = map["created"] as String?;
    final String? updated = map["updated"] as String?;
    final String? title = map["title"] as String?;
    final String? type = map["type"] as String?;
    final String? currencyCode = map["currency_code"] as String?;
    final String? colorName = map["color_name"] as String?;
    final double? balance = map["balance"] as double?;

    if (id == null || title == null) return null;

    return AccountVO(
      id: id,
      created: DateTime.tryParse(created ?? "")?.toLocal(),
      updated: DateTime.tryParse(updated ?? "")?.toLocal(),
      title: title,
      type: EAccountType.from(type ?? ""),
      currencyCode: currencyCode ?? kDefaultCurrencyCode,
      colorName: EColorName.from(colorName ?? "").name,
      balance: balance ?? .0,
    );
  }
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
