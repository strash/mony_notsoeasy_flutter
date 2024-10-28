import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";

final class TransactionBuilder {
  AccountModel? account;
  CategoryModel? category;
  List<TransactionTagModel>? tags;
  TransactionDto? dto;
  TransactionModel? model;

  TransactionBuilder addDto({required TransactionDto dto}) {
    this.dto = dto;
    return this;
  }

  TransactionBuilder addParams({
    required AccountModel account,
    required CategoryModel category,
    required List<TransactionTagModel> tags,
  }) {
    this.account = account;
    this.category = category;
    this.tags = tags;
    return this;
  }

  TransactionBuilder addModel(TransactionModel model) {
    this.model = model;
    return this;
  }

  TransactionModel buildModel() {
    final dto = this.dto;
    final account = this.account;
    final category = this.category;
    final tags = this.tags;
    if (dto == null || account == null || category == null || tags == null) {
      throw ArgumentError.notNull();
    }
    return TransactionModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      updated: DateTime.tryParse(dto.updated)?.toLocal() ?? DateTime.now(),
      amout: dto.amount.toDouble(),
      type: ETransactionType.from(dto.type),
      date: DateTime.tryParse(dto.date)?.toLocal() ?? DateTime.now(),
      note: dto.note,
      account: account,
      category: category,
      tags: tags,
    );
  }

  TransactionDto buildDto() {
    final model = this.model;
    if (model == null) throw ArgumentError.notNull();
    return TransactionDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      updated: model.updated.toUtc().toIso8601String(),
      amount: model.amout,
      type: model.type.value,
      date: model.date.toUtc().toIso8601String(),
      note: model.note,
      accountId: model.account.id,
      categoryId: model.category.id,
    );
  }
}

final class TransactionDatabaseFactoryImpl
    implements ITransactionDatabaseFactory<TransactionBuilder> {
  @override
  TransactionBuilder toModel(TransactionDto dto) {
    return TransactionBuilder()..addDto(dto: dto);
  }

  @override
  TransactionDto toDto(TransactionBuilder model) {
    return model.buildDto();
  }
}
