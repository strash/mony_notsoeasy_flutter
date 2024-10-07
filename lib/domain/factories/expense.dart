import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";

final class ExpenseDatabaseFactoryImpl
    implements IExpenseDatabaseFactory<ExpenseModel> {
  final AccountDto _accountDto;
  final CategoryDto _categoryDto;
  final List<TagDto> _tags;

  ExpenseDatabaseFactoryImpl({
    required AccountDto accountDto,
    required CategoryDto categoryDto,
    required List<TagDto> tags,
  })  : _tags = tags,
        _categoryDto = categoryDto,
        _accountDto = accountDto;

  @override
  ExpenseModel from(ExpenseDto dto) {
    final tagDatabaseFactoryImpl = TagDatabaseFactoryImpl();
    return ExpenseModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      updated: DateTime.tryParse(dto.updated)?.toLocal() ?? DateTime.now(),
      amout: dto.amout.toDouble(),
      date: DateTime.tryParse(dto.date)?.toLocal() ?? DateTime.now(),
      note: dto.note,
      account: AccountDatabaseFactoryImpl().from(_accountDto),
      category: CategoryDatabaseFactoryImpl().from(_categoryDto),
      tags: _tags.map<TagModel>((e) {
        return tagDatabaseFactoryImpl.from(e);
      }).toList(growable: false),
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
