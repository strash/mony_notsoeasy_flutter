import "dart:ui";

import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class AccountDatabaseFactoryImpl
    implements IAccountDatabaseFactory<AccountModel> {
  @override
  AccountModel from(AccountDto dto) {
    return AccountModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      updated: DateTime.tryParse(dto.updated)?.toLocal() ?? DateTime.now(),
      title: dto.title,
      type: EAccountType.from(dto.type),
      currency: FiatCurrency.fromCode(dto.currencyCode),
      color: Color(int.tryParse(dto.color) ?? 0xFFFFFFFF),
      balance: dto.balance.toDouble(),
    );
  }

  @override
  AccountDto to(AccountModel model) {
    return AccountDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      updated: model.updated.toUtc().toIso8601String(),
      title: model.title,
      type: model.type.value,
      currencyCode: model.currency.code,
      color: model.color.toHexadecimal(),
      balance: model.balance,
    );
  }
}
