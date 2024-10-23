import "package:mony_app/data/database/repository/account.dart";
import "package:mony_app/domain/domain.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class DomainAccountService extends BaseDomainService {
  final AccountDatabaseRepository _accountRepo;
  final AccountDatabaseFactoryImpl _accountFactory;

  @override
  final int perPage = 20;

  DomainAccountService({
    required AccountDatabaseRepository accountRepo,
    required AccountDatabaseFactoryImpl accountFactory,
  })  : _accountRepo = accountRepo,
        _accountFactory = accountFactory;

  Future<List<AccountModel>> getAll() async {
    final dtos = await _accountRepo.getAll();
    return dtos
        .map<AccountModel>(_accountFactory.toModel)
        .toList(growable: false);
  }

  Future<List<AccountModel>> getMany({required int page}) async {
    final dtos = await _accountRepo.getMany(
      limit: perPage,
      offset: offset(page),
    );
    return dtos
        .map<AccountModel>(_accountFactory.toModel)
        .toList(growable: false);
  }

  Future<AccountModel?> getOne({required String id}) async {
    final dto = await _accountRepo.getOne(id: id);
    if (dto == null) return null;
    return _accountFactory.toModel(dto);
  }

  Future<AccountModel> create({required AccountVO vo}) async {
    final AccountVO(:title, :type, :currencyCode, :color, :balance) = vo;
    final defaultColumns = newDefaultColumns;
    final model = AccountModel(
      id: defaultColumns.id,
      created: defaultColumns.now,
      updated: defaultColumns.now,
      title: title,
      type: type,
      currency: FiatCurrency.fromCode(currencyCode),
      color: color,
      balance: balance,
    );
    await _accountRepo.create(dto: _accountFactory.toDto(model));
    return model;
  }

  Future<AccountModel> update({required AccountModel model}) async {
    await _accountRepo.update(dto: _accountFactory.toDto(model));
    return model;
  }

  Future<void> delete({required String id}) async {
    await _accountRepo.delete(id: id);
  }
}
