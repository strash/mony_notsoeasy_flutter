import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";

final class TransactionDatabaseFactoryImpl
    implements ITransactionDatabaseFactory<BaseTransactionBuilder> {
  @override
  TransactionModelBuilder toModel(TransactionDto dto) {
    return TransactionModelBuilder()..addDto(dto: dto);
  }

  @override
  TransactionDto toDto(BaseTransactionBuilder dtoBuilder) {
    assert(dtoBuilder is TransactionDtoBuilder);
    return (dtoBuilder as TransactionDtoBuilder).build();
  }
}

sealed class BaseTransactionBuilder {}

final class TransactionModelBuilder extends BaseTransactionBuilder {
  AccountModel? _account;
  CategoryModel? _category;
  List<TagModel>? _tags;
  TransactionDto? _dto;

  TransactionModelBuilder addDto({required TransactionDto dto}) {
    _dto = dto;
    return this;
  }

  TransactionModelBuilder addAccount({required AccountModel account}) {
    _account = account;
    return this;
  }

  TransactionModelBuilder addCategory({required CategoryModel category}) {
    _category = category;
    return this;
  }

  TransactionModelBuilder addTags({required List<TagModel> tags}) {
    _tags = tags;
    return this;
  }

  TransactionModel build() {
    final dto = ArgumentError.checkNotNull(_dto);
    final account = ArgumentError.checkNotNull(_account);
    final category = ArgumentError.checkNotNull(_category);
    final tags = ArgumentError.checkNotNull(_tags);
    return TransactionModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      updated: DateTime.tryParse(dto.updated)?.toLocal() ?? DateTime.now(),
      amount: dto.amount.toDouble(),
      date: DateTime.tryParse(dto.date)?.toLocal() ?? DateTime.now(),
      note: dto.note,
      account: account,
      category: category,
      tags: tags,
    );
  }
}

final class TransactionDtoBuilder extends BaseTransactionBuilder {
  TransactionModel? _model;

  TransactionDtoBuilder addModel(TransactionModel model) {
    _model = model;
    return this;
  }

  TransactionDto build() {
    final model = ArgumentError.checkNotNull(_model);
    return TransactionDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      updated: model.updated.toUtc().toIso8601String(),
      amount: model.amount,
      date: model.date.toUtc().toIso8601String(),
      note: model.note,
      accountId: model.account.id,
      categoryId: model.category.id,
    );
  }
}
