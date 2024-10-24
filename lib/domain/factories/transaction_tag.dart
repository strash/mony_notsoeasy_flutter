import "package:mony_app/data/database/dto/transaction_tag.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";

final class TransactionTagDatabaseFactoryImpl
    implements ITransactionTagDatabaseFactory<TransactionTagModel> {
  @override
  TransactionTagModel toModel(TransactionTagDto dto) {
    return TransactionTagModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      updated: DateTime.tryParse(dto.updated)?.toLocal() ?? DateTime.now(),
      tagId: dto.tagId,
      title: dto.title,
    );
  }

  @override
  TransactionTagDto toDto(TransactionTagModel model) {
    return TransactionTagDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      updated: model.updated.toUtc().toIso8601String(),
      tagId: model.tagId,
      title: model.title,
    );
  }
}
