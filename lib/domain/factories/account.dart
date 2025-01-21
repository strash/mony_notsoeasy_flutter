import "package:mony_app/app/app.dart";
import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class AccountDatabaseFactoryImpl extends BaseDatabaseFactory
    implements IAccountDatabaseFactory<AccountModel> {
  @override
  AccountModel toModel(AccountDto dto) {
    return AccountModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      updated: DateTime.tryParse(dto.updated)?.toLocal() ?? DateTime.now(),
      title: dto.title,
      type: EAccountType.from(dto.type),
      currency: FiatCurrency.fromCode(dto.currencyCode),
      colorName: EColorName.from(dto.colorName),
      balance: dto.balance.toDouble(),
    );
  }

  @override
  AccountDto toDto(AccountModel model) {
    return AccountDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      updated: model.updated.toUtc().toIso8601String(),
      title: model.title,
      type: model.type.value,
      currencyCode: model.currency.code,
      colorName: model.colorName.name,
      balance: model.balance,
    );
  }

  AccountModel fromVO(AccountVO vo) {
    final defaultColumns = newDefaultColumns;
    return AccountModel(
      id: vo.id ?? defaultColumns.id,
      created: vo.created ?? defaultColumns.now,
      updated: vo.updated ?? defaultColumns.now,
      title: vo.title,
      type: vo.type,
      currency: FiatCurrency.fromCode(vo.currencyCode),
      colorName: EColorName.from(vo.colorName),
      balance: vo.balance,
    );
  }
}
