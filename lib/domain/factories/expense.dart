import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";

final class ExpenseDatabaseFactoryImpl
    implements IExpenseDatabaseFactory<ExpenseModel> {
  final AccountDto _accountDto;
  final CategoryDto _categoryDto;
  final List<TagDto> _tags;

  final AccountDatabaseFactoryImpl _accountFactory;
  final CategoryDatabaseFactoryImpl _categoryFactory;
  final TagDatabaseFactoryImpl _tagFactory;

  ExpenseDatabaseFactoryImpl({
    required AccountDto accountDto,
    required CategoryDto categoryDto,
    required List<TagDto> tags,
    required AccountDatabaseFactoryImpl accountFactory,
    required CategoryDatabaseFactoryImpl categoryFactory,
    required TagDatabaseFactoryImpl tagFactory,
  })  : _tags = tags,
        _categoryDto = categoryDto,
        _accountDto = accountDto,
        _accountFactory = accountFactory,
        _categoryFactory = categoryFactory,
        _tagFactory = tagFactory;

  @override
  ExpenseModel from(ExpenseDto dto) {
    return ExpenseModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      updated: DateTime.tryParse(dto.updated)?.toLocal() ?? DateTime.now(),
      amout: dto.amout.toDouble(),
      date: DateTime.tryParse(dto.date)?.toLocal() ?? DateTime.now(),
      note: dto.note,
      account: _accountFactory.from(_accountDto),
      category: _categoryFactory.from(_categoryDto),
      tags: _tags
          .map<TagModel>((e) => _tagFactory.from(e))
          .toList(growable: false),
    );
  }

  @override
  ExpenseDto to(ExpenseModel model) {
    return ExpenseDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      updated: model.updated.toUtc().toIso8601String(),
      amout: model.amout,
      date: model.date.toUtc().toIso8601String(),
      note: model.note,
      accountId: model.account.id,
      categoryId: model.category.id,
    );
  }
}
