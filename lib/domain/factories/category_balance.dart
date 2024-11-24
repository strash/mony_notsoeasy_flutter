import "dart:convert";

import "package:mony_app/data/database/dto/category_balance.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class CategoryBalanceDatabaseFactoryImpl
    implements ICategoryBalanceDatabaseFactory<CategoryBalanceModel> {
  @override
  CategoryBalanceModel toModel(CategoryBalanceDto dto) {
    final map = jsonDecode(dto.totalSums) as Map<String, dynamic>;
    return CategoryBalanceModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      totalSums: Map.fromEntries(
        map.entries.map((e) {
          return MapEntry(
            FiatCurrency.fromCode(e.key),
            double.tryParse(e.value.toString()) ?? .0,
          );
        }),
      ),
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
      totalSums: model.totalSums.entries
          .map((e) => MapEntry(e.key.code, e.value))
          .toString(),
      firstTransactionDate:
          model.firstTransactionDate?.toUtc().toIso8601String(),
      lastTransactionDate: model.lastTransactionDate?.toUtc().toIso8601String(),
    );
  }
}
