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
    final AccountVO(
      :id,
      :created,
      :updated,
      :title,
      :type,
      :currencyCode,
      :colorName,
      :balance
    ) = vo;
    return AccountModel(
      id: id ?? defaultColumns.id,
      created: created ?? defaultColumns.now,
      updated: updated ?? defaultColumns.now,
      title: title,
      type: type,
      currency: FiatCurrency.fromCode(currencyCode),
      colorName: EColorName.from(colorName),
      balance: balance,
    );
  }
}
