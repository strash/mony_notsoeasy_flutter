import "package:mony_app/data/database/dto/category_balance.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";

final class CategoryBalanceDatabaseFactoryImpl
    implements ICategoryBalanceDatabaseFactory<CategoryBalanceModel> {
  @override
  CategoryBalanceModel toModel(CategoryBalanceDto dto) {
    return CategoryBalanceModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      totalSum: dto.totalSum.toDouble(),
      firstTransactionDate: DateTime.tryParse(dto.firstTransactionDate ?? ""),
      lastTransactionDate: DateTime.tryParse(dto.lastTransactionDate ?? ""),
      transactionsCount: dto.transactionsCount,
    );
  }

  @override
  CategoryBalanceDto toDto(CategoryBalanceModel model) {
    return CategoryBalanceDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      transactionsCount: model.transactionsCount,
      totalSum: model.totalSum,
      firstTransactionDate:
          model.firstTransactionDate?.toUtc().toIso8601String(),
      lastTransactionDate: model.lastTransactionDate?.toUtc().toIso8601String(),
    );
  }
}
