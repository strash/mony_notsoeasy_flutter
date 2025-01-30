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
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      currency: FiatCurrency.fromCode(dto.currencyCode),
      balance: dto.balance.toDouble(),
      totalAmount: dto.totalAmount.toDouble(),
      expenseAmount: dto.expenseAmount.toDouble(),
      incomeAmount: dto.incomeAmount.toDouble(),
      totalCount: dto.totalCount,
      expenseCount: dto.expenseCount,
      incomeCount: dto.incomeCount,
      firstTransactionDate: DateTime.tryParse(dto.firstTransactionDate ?? ""),
      lastTransactionDate: DateTime.tryParse(dto.lastTransactionDate ?? ""),
    );
  }

  @override
  AccountBalanceDto toDto(AccountBalanceModel model) {
    return AccountBalanceDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      currencyCode: model.currency.code,
      balance: model.balance,
      totalAmount: model.totalAmount,
      expenseAmount: model.expenseAmount,
      incomeAmount: model.incomeAmount,
      totalCount: model.totalCount,
      expenseCount: model.expenseCount,
      incomeCount: model.incomeCount,
      firstTransactionDate:
          model.firstTransactionDate?.toUtc().toIso8601String(),
      lastTransactionDate: model.lastTransactionDate?.toUtc().toIso8601String(),
    );
  }
}
