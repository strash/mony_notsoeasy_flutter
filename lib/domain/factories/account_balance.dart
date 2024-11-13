import "package:mony_app/data/database/dto/account_balance.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/models/account_balance.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class AccountBalanceDatabaseFactoryImpl
    implements IAccountBalanceDatabaseFactory<AccountBalanceModel> {
  @override
  AccountBalanceModel toModel(AccountBalanceDto dto) {
    return AccountBalanceModel(
      id: dto.id,
      currency: FiatCurrency.fromCode(dto.currencyCode),
      balance: dto.balance.toDouble(),
      totalAmount: dto.totalAmount.toDouble(),
      totalSum: dto.totalSum.toDouble(),
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
    );
  }

  @override
  AccountBalanceDto toDto(AccountBalanceModel model) {
    return AccountBalanceDto(
      id: model.id,
      currencyCode: model.currency.code,
      balance: model.balance,
      totalAmount: model.totalAmount,
      totalSum: model.totalSum,
      created: model.created.toUtc().toIso8601String(),
    );
  }
}
