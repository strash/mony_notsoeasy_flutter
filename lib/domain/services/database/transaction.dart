import "package:mony_app/data/database/database.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/transaction_form/page/form_vo.dart";

final class DomainTransactionService extends BaseDatabaseService {
  final TransactionDatabaseRepository _transactionRepo;
  final TransactionTagDatabaseRepository _transactionTagRepo;
  final TagDatabaseRepository _tagRepo;
  final AccountDatabaseRepository _accountRepo;
  final CategoryDatabaseRepository _categoryRepo;
  final TransactionDatabaseFactoryImpl _transactionFactory;
  final TransactionTagDatabaseFactoryImpl _transactionTagFactory;
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
    required TransactionTagDatabaseFactoryImpl transactionTagFactory,
    required TagDatabaseFactoryImpl tagFactory,
    required AccountDatabaseFactoryImpl accountFactory,
    required CategoryDatabaseFactoryImpl categoryFactory,
  })  : _transactionRepo = transactionRepo,
        _transactionTagRepo = transactionTagRepo,
        _tagRepo = tagRepo,
        _accountRepo = accountRepo,
        _categoryRepo = categoryRepo,
        _transactionFactory = transactionFactory,
        _transactionTagFactory = transactionTagFactory,
        _tagFactory = tagFactory,
        _accountFactory = accountFactory,
        _categoryFactory = categoryFactory;

  @override
  int get perPage => 40;

  Future<List<TransactionModel>> getAll({
    String? accountId,
    String? categoryId,
  }) async {
    final dtos = await _transactionRepo.getAll(
      accountId: accountId,
      categoryId: categoryId,
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
        await _categoryRepo.getAll(ids: categoryIds.toList(growable: false));
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

  Future<List<TransactionModel>> getMany({
    required int page,
    String? accountId,
    String? categoryId,
  }) async {
    final dtos = await _transactionRepo.getMany(
      limit: perPage,
      offset: offset(page),
      accountId: accountId,
      categoryId: categoryId,
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
        await _categoryRepo.getAll(ids: categoryIds.toList(growable: false));
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
      date: vo.date.toUtc().toIso8601String(),
      note: vo.note,
      accountId: vo.accountId,
      categoryId: vo.categoryId,
    );
    final accountDto = await _accountRepo.getOne(id: dto.accountId);
    final categoryDto = await _categoryRepo.getOne(id: dto.categoryId);
    if (accountDto == null || categoryDto == null) return null;
    await _transactionRepo.create(dto: dto);
    final List<TransactionTagDto> transactionTagDtos = [];
    Future.wait<void>(
      vo.tagIds.map<Future<void>>((e) {
        final tagDefaultColumns = newDefaultColumns;
        final tagDto = TransactionTagDto(
          id: tagDefaultColumns.id,
          created: tagDefaultColumns.now.toUtc().toIso8601String(),
          updated: tagDefaultColumns.now.toUtc().toIso8601String(),
          transactionId: dto.id,
          tagId: e,
        );
        transactionTagDtos.add(tagDto);
        return _transactionTagRepo.create(dto: tagDto);
      }),
    );
    final model = _transactionFactory.toModel(dto)
      ..addParams(
        account: _accountFactory.toModel(accountDto),
        category: _categoryFactory.toModel(categoryDto),
        tags: transactionTagDtos
            .map<TransactionTagModel>(_transactionTagFactory.toModel)
            .toList(growable: false),
      );
    return model.buildModel();
  }

  Future<TransactionModel?> update({
    required TransactionModel transaction,
    required TransactionFormVO vo,
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

    // delete all old transaction tags
    await Future.wait(
      transaction.tags.map((e) => unlinkTag(transactionTagId: e.id)),
    );

    // create new tags if needed
    final List<TagModel> tagModels = [];
    Future.wait<void>(
      vo.tags.map((e) {
        switch (e) {
          case final TransactionFormTagVO tag:
            final defaultColumns = newDefaultColumns;
            final dto = TagDto(
              id: defaultColumns.id,
              created: defaultColumns.now.toUtc().toIso8601String(),
              updated: defaultColumns.now.toUtc().toIso8601String(),
              title: tag.vo.title,
            );
            tagModels.add(_tagFactory.toModel(dto));
            return _tagRepo.create(dto: dto);
          case final TransactionTagFormModel tag:
            tagModels.add(tag.model);
            return Future.value();
        }
      }),
    );

    // creating new links to the tags
    final List<TransactionTagDto> transactionTagDtos = [];
    Future.wait<void>(
      tagModels.map<Future<void>>((e) {
        final tagDefaultColumns = newDefaultColumns;
        final tagDto = TransactionTagDto(
          id: tagDefaultColumns.id,
          created: tagDefaultColumns.now.toUtc().toIso8601String(),
          updated: tagDefaultColumns.now.toUtc().toIso8601String(),
          transactionId: transaction.id,
          tagId: e.id,
        );
        transactionTagDtos.add(tagDto);
        return _transactionTagRepo.create(dto: tagDto);
      }),
    );

    // updating model
    await _transactionRepo.update(dto: dto);
    final model = _transactionFactory.toModel(dto)
      ..addParams(
        account: _accountFactory.toModel(accountDto),
        category: _categoryFactory.toModel(categoryDto),
        tags: transactionTagDtos
            .map<TransactionTagModel>(_transactionTagFactory.toModel)
            .toList(growable: false),
      );
    return model.buildModel();
  }

  Future<void> delete({required String id}) async {
    await _transactionRepo.delete(id: id);
  }

  Future<void> unlinkTag({required String transactionTagId}) async {
    await _transactionTagRepo.delete(id: transactionTagId);
  }
}
