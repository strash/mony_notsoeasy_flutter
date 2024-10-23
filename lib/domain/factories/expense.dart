import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";

final class ExpenseDatabaseFactoryImpl
    implements IExpenseDatabaseFactory<ExpenseModel> {
  final AccountDto _accountDto;
  final CategoryDto _categoryDto;
  final List<ExpenseTagDto> _tags;

  final AccountDatabaseFactoryImpl _accountFactory;
  final CategoryDatabaseFactoryImpl _categoryFactory;
  final ExpenseTagDatabaseFactoryImpl _expenseTagFactory;

  ExpenseDatabaseFactoryImpl({
    required AccountDto accountDto,
    required CategoryDto categoryDto,
    required List<ExpenseTagDto> tags,
    required AccountDatabaseFactoryImpl accountFactory,
    required CategoryDatabaseFactoryImpl categoryFactory,
    required ExpenseTagDatabaseFactoryImpl expenseTagFactory,
  })  : _tags = tags,
        _categoryDto = categoryDto,
        _accountDto = accountDto,
        _accountFactory = accountFactory,
        _categoryFactory = categoryFactory,
        _expenseTagFactory = expenseTagFactory;

  @override
  ExpenseModel toModel(ExpenseDto dto) {
    return ExpenseModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      updated: DateTime.tryParse(dto.updated)?.toLocal() ?? DateTime.now(),
      amout: dto.amout.toDouble(),
      type: EExpenseType.from(dto.type),
      date: DateTime.tryParse(dto.date)?.toLocal() ?? DateTime.now(),
      note: dto.note,
      account: _accountFactory.toModel(_accountDto),
      category: _categoryFactory.toModel(_categoryDto),
      tags: _tags
          .map<ExpenseTagModel>(_expenseTagFactory.toModel)
          .toList(growable: false),
    );
  }

  @override
  ExpenseDto toDto(ExpenseModel model) {
    return ExpenseDto(
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
