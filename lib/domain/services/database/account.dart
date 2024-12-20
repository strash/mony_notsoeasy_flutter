import "package:mony_app/app/app.dart";
import "package:mony_app/data/database/repository/account.dart";
import "package:mony_app/domain/domain.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class DomainAccountService extends BaseDatabaseService {
  final AccountDatabaseRepository _accountRepo;
  final AccountDatabaseFactoryImpl _accountFactory;
  final AccountBalanceDatabaseFactoryImpl _accountBalanceFactory;

  @override
  final int perPage = 20;

  DomainAccountService({
    required AccountDatabaseRepository accountRepo,
    required AccountDatabaseFactoryImpl accountFactory,
    required AccountBalanceDatabaseFactoryImpl accountBalanceFactory,
  })  : _accountRepo = accountRepo,
        _accountFactory = accountFactory,
        _accountBalanceFactory = accountBalanceFactory;

  Future<int> count() async {
    return await _accountRepo.count();
  }

  Future<List<AccountBalanceModel>> getBalances() async {
    final dtos = await _accountRepo.getBalances();
    return dtos
        .map<AccountBalanceModel>(_accountBalanceFactory.toModel)
        .toList(growable: false);
  }

  Future<AccountBalanceModel?> getBalance({required String id}) async {
    final dto = await _accountRepo.getBalance(id: id);
    if (dto == null) return null;
    return _accountBalanceFactory.toModel(dto);
  }

  Future<List<AccountModel>> getAll({EAccountType? type}) async {
    final dtos = await _accountRepo.getAll(type: type?.value);
    return dtos
        .map<AccountModel>(_accountFactory.toModel)
        .toList(growable: false);
  }

  Future<List<AccountModel>> getMany({
    EAccountType? type,
    required int page,
  }) async {
    final dtos = await _accountRepo.getMany(
      type: type?.value,
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
    final AccountVO(:title, :type, :currencyCode, :colorName, :balance) = vo;
    final defaultColumns = newDefaultColumns;
    final model = AccountModel(
      id: defaultColumns.id,
      created: defaultColumns.now,
      updated: defaultColumns.now,
      title: title,
      type: type,
      currency: FiatCurrency.fromCode(currencyCode),
      colorName: EColorName.from(colorName),
      balance: balance,
    );
    await _accountRepo.create(dto: _accountFactory.toDto(model));
    return model;
  }

  Future<AccountModel> update({required AccountModel model}) async {
    await _accountRepo.update(
      dto: _accountFactory.toDto(model.copyWith(updated: DateTime.now())),
    );
    return model;
  }

  Future<void> delete({required String id}) async {
    await _accountRepo.delete(id: id);
  }
}
