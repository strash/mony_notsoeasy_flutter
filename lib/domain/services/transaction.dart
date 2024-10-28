import "package:mony_app/data/database/database.dart";
import "package:mony_app/domain/domain.dart";

final class DomainTransactionService extends BaseDomainService {
  final TransactionDatabaseRepository _transactionRepo;
  final TransactionTagDatabaseRepository _transactionTagRepo;
  final AccountDatabaseRepository _accountRepo;
  final CategoryDatabaseRepository _categoryRepo;
  final TransactionDatabaseFactoryImpl _transactionFactory;
  final TransactionTagDatabaseFactoryImpl _transactionTagFactory;
  final AccountDatabaseFactoryImpl _accountFactory;
  final CategoryDatabaseFactoryImpl _categoryFactory;

  DomainTransactionService({
    required TransactionDatabaseRepository transactionRepo,
    required TransactionTagDatabaseRepository transactionTagRepo,
    required AccountDatabaseRepository accountRepo,
    required CategoryDatabaseRepository categoryRepo,
    required TransactionDatabaseFactoryImpl transactionFactory,
    required TransactionTagDatabaseFactoryImpl transactionTagFactory,
    required AccountDatabaseFactoryImpl accountFactory,
    required CategoryDatabaseFactoryImpl categoryFactory,
  })  : _transactionRepo = transactionRepo,
        _transactionTagRepo = transactionTagRepo,
        _accountRepo = accountRepo,
        _categoryRepo = categoryRepo,
        _transactionFactory = transactionFactory,
        _transactionTagFactory = transactionTagFactory,
        _accountFactory = accountFactory,
        _categoryFactory = categoryFactory;

  @override
  int get perPage => 40;

  // TODO: фильтровать по счету или категории
  Future<List<TransactionModel>> getAll() async {
    final dtos = await _transactionRepo.getAll();
    final Set<String> accountIds = {};
    final Set<String> categoryIds = {};
    for (final element in dtos) {
      accountIds.add(element.accountId);
      categoryIds.add(element.categoryId);
    }
    final accountDtos =
        await _accountRepo.getAll(ids: accountIds.toList(growable: false));
    final categoryDtos =
        await _categoryRepo.getAll(ids: accountIds.toList(growable: false));
    final tagDtos = await Future.wait<List<TransactionTagDto>>(
      dtos.map<Future<List<TransactionTagDto>>>((e) {
        return _transactionTagRepo.getAll(transactionId: e.id);
      }),
    );
    final List<TransactionModel> models = [];
    for (final element in dtos.indexed) {
      final model = _transactionFactory.toModel(element.$2)
        ..addParams(
          account: _accountFactory.toModel(
            accountDtos.singleWhere((e) => e.id == element.$2.accountId),
          ),
          category: _categoryFactory.toModel(
            categoryDtos.singleWhere((e) => e.id == element.$2.categoryId),
          ),
          tags: tagDtos
              .elementAt(element.$1)
              .map<TransactionTagModel>(_transactionTagFactory.toModel)
              .toList(growable: false),
        );
      models.add(model.buildModel());
    }
    return models;
  }

  // TODO: фильтровать по счету или категории
  Future<List<TransactionModel>> getMany({required int page}) async {
    final dtos = await _transactionRepo.getMany(
      limit: perPage,
      offset: offset(page),
    );
    final Set<String> accountIds = {};
    final Set<String> categoryIds = {};
    for (final element in dtos) {
      accountIds.add(element.accountId);
      categoryIds.add(element.categoryId);
    }
    final accountDtos =
        await _accountRepo.getAll(ids: accountIds.toList(growable: false));
    final categoryDtos =
        await _categoryRepo.getAll(ids: accountIds.toList(growable: false));
    final tagDtos = await Future.wait<List<TransactionTagDto>>(
      dtos.map<Future<List<TransactionTagDto>>>((e) {
        return _transactionTagRepo.getAll(transactionId: e.id);
      }),
    );
    final List<TransactionModel> models = [];
    for (final element in dtos.indexed) {
      final model = _transactionFactory.toModel(element.$2)
        ..addParams(
          account: _accountFactory.toModel(
            accountDtos.singleWhere((e) => e.id == element.$2.accountId),
          ),
          category: _categoryFactory.toModel(
            categoryDtos.singleWhere((e) => e.id == element.$2.categoryId),
          ),
          tags: tagDtos
              .elementAt(element.$1)
              .map<TransactionTagModel>(_transactionTagFactory.toModel)
              .toList(growable: false),
        );
      models.add(model.buildModel());
    }
    return models;
  }

  Future<TransactionModel?> create({required TransactionVO vo}) async {
    final defaultColumns = newDefaultColumns;
    final dto = TransactionDto(
      id: defaultColumns.id,
      created: defaultColumns.now.toUtc().toIso8601String(),
      updated: defaultColumns.now.toUtc().toIso8601String(),
      amount: vo.amout,
      type: vo.type.value,
      date: vo.date.toUtc().toIso8601String(),
      note: vo.note,
      accountId: vo.accountId,
      categoryId: vo.categoryId,
    );
    final accountDto = await _accountRepo.getOne(id: dto.accountId);
    final categoryDto = await _categoryRepo.getOne(id: dto.categoryId);
    if (accountDto == null || categoryDto == null) return null;
    await _transactionRepo.create(dto: dto);
    final List<TransactionTagDto> tagDtos = [];
    Future.wait<void>(
      vo.tags.map<Future<void>>((e) {
        final tagDefaultColumns = newDefaultColumns;
        final tagDto = TransactionTagDto(
          id: tagDefaultColumns.id,
          created: tagDefaultColumns.now.toUtc().toIso8601String(),
          updated: tagDefaultColumns.now.toUtc().toIso8601String(),
          transactionId: dto.id,
          tagId: e.tagId,
          title: e.title,
        );
        tagDtos.add(tagDto);
        return _transactionTagRepo.create(dto: tagDto);
      }),
    );
    final model = _transactionFactory.toModel(dto)
      ..addParams(
        account: _accountFactory.toModel(accountDto),
        category: _categoryFactory.toModel(categoryDto),
        tags: tagDtos
            .map<TransactionTagModel>(_transactionTagFactory.toModel)
            .toList(growable: false),
      );
    return model.buildModel();
  }

  // TODO: update

  Future<void> delete({required String id}) async {
    await _transactionRepo.delete(id: id);
  }

  Future<void> unlinkTag({required String transactionTagId}) async {
    await _transactionTagRepo.delete(id: transactionTagId);
  }
}
