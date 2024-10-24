import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";

final class TransactionDatabaseFactoryImpl
    implements ITransactionDatabaseFactory<TransactionModel> {
  final AccountDto _accountDto;
  final CategoryDto _categoryDto;
  final List<TransactionTagDto> _tags;

  final AccountDatabaseFactoryImpl _accountFactory;
  final CategoryDatabaseFactoryImpl _categoryFactory;
  final TransactionTagDatabaseFactoryImpl _transactionTagFactory;

  TransactionDatabaseFactoryImpl({
    required AccountDto accountDto,
    required CategoryDto categoryDto,
    required List<TransactionTagDto> tags,
    required AccountDatabaseFactoryImpl accountFactory,
    required CategoryDatabaseFactoryImpl categoryFactory,
    required TransactionTagDatabaseFactoryImpl transactionTagFactory,
  })  : _tags = tags,
        _categoryDto = categoryDto,
        _accountDto = accountDto,
        _accountFactory = accountFactory,
        _categoryFactory = categoryFactory,
        _transactionTagFactory = transactionTagFactory;

  @override
  TransactionModel toModel(TransactionDto dto) {
    return TransactionModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      updated: DateTime.tryParse(dto.updated)?.toLocal() ?? DateTime.now(),
      amout: dto.amout.toDouble(),
      type: ETransactionType.from(dto.type),
      date: DateTime.tryParse(dto.date)?.toLocal() ?? DateTime.now(),
      note: dto.note,
      account: _accountFactory.toModel(_accountDto),
      category: _categoryFactory.toModel(_categoryDto),
      tags: _tags
          .map<TransactionTagModel>(_transactionTagFactory.toModel)
          .toList(growable: false),
    );
  }

  @override
  TransactionDto toDto(TransactionModel model) {
    return TransactionDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      updated: model.updated.toUtc().toIso8601String(),
      amout: model.amout,
      type: model.type.value,
      date: model.date.toUtc().toIso8601String(),
      note: model.note,
      accountId: model.account.id,
      categoryId: model.category.id,
    );
  }
}
