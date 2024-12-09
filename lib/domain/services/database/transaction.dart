import "package:mony_app/data/database/database.dart";
import "package:mony_app/domain/domain.dart";

final class DomainTransactionService extends BaseDatabaseService {
  final TransactionDatabaseRepository _transactionRepo;
  final TransactionTagDatabaseRepository _transactionTagRepo;
  final TagDatabaseRepository _tagRepo;
  final AccountDatabaseRepository _accountRepo;
  final CategoryDatabaseRepository _categoryRepo;
  final TransactionDatabaseFactoryImpl _transactionFactory;
  final TagDatabaseFactoryImpl _tagFactory;
  final AccountDatabaseFactoryImpl _accountFactory;
  final CategoryDatabaseFactoryImpl _categoryFactory;

  DomainTransactionService({
    required TransactionDatabaseRepository transactionRepo,
    required TransactionTagDatabaseRepository transactionTagRepo,
    required TagDatabaseRepository tagRepo,
    required AccountDatabaseRepository accountRepo,
    required CategoryDatabaseRepository categoryRepo,
    required TransactionDatabaseFactoryImpl transactionFactory,
    required TagDatabaseFactoryImpl tagFactory,
    required AccountDatabaseFactoryImpl accountFactory,
    required CategoryDatabaseFactoryImpl categoryFactory,
  })  : _transactionRepo = transactionRepo,
        _transactionTagRepo = transactionTagRepo,
        _tagRepo = tagRepo,
        _accountRepo = accountRepo,
        _categoryRepo = categoryRepo,
        _transactionFactory = transactionFactory,
        _tagFactory = tagFactory,
        _accountFactory = accountFactory,
        _categoryFactory = categoryFactory;

  @override
  int get perPage => 40;

  Future<List<TransactionModel>> getAll({
    List<String>? accountIds,
    List<String>? categoryIds,
    List<String>? tagIds,
  }) async {
    final dtos = await _transactionRepo.getAll(
      accountIds: accountIds,
      categoryIds: categoryIds,
      tagIds: tagIds,
    );
    final Set<String> unqAccountIds = {};
    final Set<String> unqCategoryIds = {};
    for (final element in dtos) {
      unqAccountIds.add(element.accountId);
      unqCategoryIds.add(element.categoryId);
    }
    final accountDtos = await _accountRepo.getAll(
      ids: List<String>.from(unqAccountIds),
    );
    final categoryDtos = await _categoryRepo.getAll(
      ids: List<String>.from(unqCategoryIds),
    );
    final tagDtos = await Future.wait(
      dtos.map((e) => _tagRepo.getAll(transactionId: e.id)),
    );
    final List<TransactionModel> models = [];
    for (final (index, dto) in dtos.indexed) {
      final model = _transactionFactory.toModel(dto)
        ..addAccount(
          account: _accountFactory.toModel(
            accountDtos.singleWhere((e) => e.id == dto.accountId),
          ),
        )
        ..addCategory(
          category: _categoryFactory.toModel(
            categoryDtos.singleWhere((e) => e.id == dto.categoryId),
          ),
        )
        ..addTags(
          tags: tagDtos
              .elementAt(index)
              .map<TagModel>(_tagFactory.toModel)
              .toList(growable: false),
        );
      models.add(model.build());
    }
    return models;
  }

  Future<List<TransactionModel>> getMany({
    required int page,
    List<String>? accountIds,
    List<String>? categoryIds,
    List<String>? tagIds,
  }) async {
    final dtos = await _transactionRepo.getMany(
      limit: perPage,
      offset: offset(page),
      accountIds: accountIds,
      categoryIds: categoryIds,
      tagIds: tagIds,
    );
    final Set<String> unqAccountIds = {};
    final Set<String> unqCategoryIds = {};
    for (final element in dtos) {
      unqAccountIds.add(element.accountId);
      unqCategoryIds.add(element.categoryId);
    }
    final accountDtos = await _accountRepo.getAll(
      ids: List<String>.from(unqAccountIds),
    );
    final categoryDtos = await _categoryRepo.getAll(
      ids: List<String>.from(unqCategoryIds),
    );
    final tagDtos = await Future.wait(
      dtos.map((e) => _tagRepo.getAll(transactionId: e.id)),
    );
    final List<TransactionModel> models = [];
    for (final (index, dto) in dtos.indexed) {
      final model = _transactionFactory.toModel(dto)
        ..addAccount(
          account: _accountFactory.toModel(
            accountDtos.singleWhere((e) => e.id == dto.accountId),
          ),
        )
        ..addCategory(
          category: _categoryFactory.toModel(
            categoryDtos.singleWhere((e) => e.id == dto.categoryId),
          ),
        )
        ..addTags(
          tags: tagDtos
              .elementAt(index)
              .map<TagModel>(_tagFactory.toModel)
              .toList(growable: false),
        );
      models.add(model.build());
    }
    return models;
  }

  Future<TransactionModel?> create({
    required TransactionVO vo,
    required List<TransactionTagVariant> tags,
  }) async {
    final defaultColumns = newDefaultColumns;
    final dto = TransactionDto(
      id: defaultColumns.id,
      created: defaultColumns.now.toUtc().toIso8601String(),
      updated: defaultColumns.now.toUtc().toIso8601String(),
      amount: vo.amout,
      date: vo.date.toUtc().toIso8601String(),
      note: vo.note,
      accountId: vo.accountId,
      categoryId: vo.categoryId,
    );
    final accountDto = await _accountRepo.getOne(id: dto.accountId);
    final categoryDto = await _categoryRepo.getOne(id: dto.categoryId);
    if (accountDto == null || categoryDto == null) return null;
    // create transaction
    await _transactionRepo.create(dto: dto);
    // create/gather tags
    final tagModels = await Future.wait<TagModel>(
      tags.map((e) {
        switch (e) {
          case TransactionTagVariantVO(:final vo):
            final tagDefaultColumns = newDefaultColumns;
            final tagDto = TagDto(
              id: tagDefaultColumns.id,
              created: tagDefaultColumns.now.toUtc().toIso8601String(),
              updated: tagDefaultColumns.now.toUtc().toIso8601String(),
              title: vo.title,
            );
            _tagRepo.create(dto: tagDto);
            return Future.value(_tagFactory.toModel(tagDto));
          case TransactionTagVariantModel(:final model):
            return Future.value(model);
        }
      }),
    );
    // create transaction tags
    Future.wait<void>(
      tagModels.map((e) {
        final transactionTagDefaultColumns = newDefaultColumns;
        final transactionTagDto = TransactionTagDto(
          id: transactionTagDefaultColumns.id,
          created: transactionTagDefaultColumns.now.toUtc().toIso8601String(),
          updated: transactionTagDefaultColumns.now.toUtc().toIso8601String(),
          transactionId: dto.id,
          tagId: e.id,
        );
        return _transactionTagRepo.create(dto: transactionTagDto);
      }),
    );
    return (_transactionFactory.toModel(dto)
          ..addAccount(account: _accountFactory.toModel(accountDto))
          ..addCategory(category: _categoryFactory.toModel(categoryDto))
          ..addTags(tags: tagModels))
        .build();
  }

  Future<TransactionModel?> update({
    required TransactionModel transaction,
    required TransactionVO vo,
    required List<TransactionTagVariant> tags,
  }) async {
    final defaultColumns = newDefaultColumns;
    final dto = TransactionDto(
      id: transaction.id,
      created: transaction.created.toUtc().toIso8601String(),
      updated: defaultColumns.now.toUtc().toIso8601String(),
      amount: vo.amout,
      date: vo.date.toUtc().toIso8601String(),
      note: vo.note,
      accountId: vo.accountId,
      categoryId: vo.categoryId,
    );
    final accountDto = await _accountRepo.getOne(id: dto.accountId);
    final categoryDto = await _categoryRepo.getOne(id: dto.categoryId);
    if (accountDto == null || categoryDto == null) return null;
    // delete old transaction tags
    final oldTransactionTagDtos =
        await _transactionTagRepo.getAll(transactionId: transaction.id);
    await Future.wait(
      oldTransactionTagDtos.map((e) => _transactionTagRepo.delete(id: e.id)),
    );
    // create/gather tags
    final List<TagModel> tagModels = await Future.wait<TagModel>(
      tags.map((e) {
        switch (e) {
          case TransactionTagVariantVO(:final vo):
            final tagDefaultColumns = newDefaultColumns;
            final tagDto = TagDto(
              id: tagDefaultColumns.id,
              created: tagDefaultColumns.now.toUtc().toIso8601String(),
              updated: tagDefaultColumns.now.toUtc().toIso8601String(),
              title: vo.title,
            );
            _tagRepo.create(dto: tagDto);
            return Future.value(_tagFactory.toModel(tagDto));
          case TransactionTagVariantModel(:final model):
            return Future.value(model);
        }
      }),
    );
    // creating new transaction tags
    Future.wait<void>(
      tagModels.map((e) {
        final transactionTagDefaultColumns = newDefaultColumns;
        final transactionTagDto = TransactionTagDto(
          id: transactionTagDefaultColumns.id,
          created: transactionTagDefaultColumns.now.toUtc().toIso8601String(),
          updated: transactionTagDefaultColumns.now.toUtc().toIso8601String(),
          transactionId: transaction.id,
          tagId: e.id,
        );
        return _transactionTagRepo.create(dto: transactionTagDto);
      }),
    );
    // update model
    await _transactionRepo.update(dto: dto);
    return (_transactionFactory.toModel(dto)
          ..addAccount(account: _accountFactory.toModel(accountDto))
          ..addCategory(category: _categoryFactory.toModel(categoryDto))
          ..addTags(tags: tagModels))
        .build();
  }

  Future<void> delete({required String id}) async {
    await _transactionRepo.delete(id: id);
  }
}
