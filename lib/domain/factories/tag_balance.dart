import "dart:convert";

import "package:mony_app/data/database/dto/tag_balance.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/models/tag_balance.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class TagBalanceDatabaseFactoryImpl
    implements ITagBalanceDatabaseFactory<TagBalanceModel> {
  @override
  TagBalanceModel toModel(TagBalanceDto dto) {
    final map = jsonDecode(dto.totalAmount) as Map<String, dynamic>;
    return TagBalanceModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      totalAmount: Map.fromEntries(
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
  TagBalanceDto toDto(TagBalanceModel model) {
    return TagBalanceDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      transactionsCount: model.transactionsCount,
      totalAmount: model.totalAmount.entries
          .map((e) => MapEntry(e.key.code, e.value))
          .toString(),
      firstTransactionDate:
          model.firstTransactionDate?.toUtc().toIso8601String(),
      lastTransactionDate: model.lastTransactionDate?.toUtc().toIso8601String(),
    );
  }
}
