import "package:mony_app/common/common.dart";
import "package:mony_app/data/database/repository/repository.dart";
import "package:mony_app/domain/domain.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class AccountService {
  final AccountDatabaseRepository _accountRepo;
  final AccountDatabaseFactoryImpl _accountFactory;

  static const int kPerPage = 10;

  AccountService({
    required AccountDatabaseRepository accountRepo,
    required AccountDatabaseFactoryImpl accountFactory,
  })  : _accountRepo = accountRepo,
        _accountFactory = accountFactory;

  Future<List<AccountModel>> getAll() async {
    final data = await _accountRepo.getAll();
    return data
        .map<AccountModel>((e) => _accountFactory.from(e))
        .toList(growable: false);
  }

  Future<List<AccountModel>> getMany(int page) async {
    final data = await _accountRepo.getMany(
      limit: kPerPage,
      offset: kPerPage * page,
    );
    return data
        .map<AccountModel>((e) => _accountFactory.from(e))
        .toList(growable: false);
  }

  Future<AccountModel?> getOne(String id) async {
    final data = await _accountRepo.getOne(id: id);
    if (data == null) return null;
    return _accountFactory.from(data);
  }

  Future<AccountModel> create(AccountValueObject obj) async {
    if (obj is! AccountCreateValueObject) throw ArgumentError.value(obj);
    final AccountCreateValueObject(
      :title,
      :type,
      :currencyCode,
      :color,
      :balance
    ) = obj;
    final model = AccountModel(
      id: StringEx.random(20),
      created: DateTime.now(),
      updated: DateTime.now(),
      title: title,
      type: type,
      currency: FiatCurrency.fromCode(currencyCode),
      color: color,
      balance: balance,
    );
    await _accountRepo.create(dto: _accountFactory.to(model));
    return model;
  }

  Future<AccountModel> update(AccountValueObject obj) async {
    if (obj is! AccountUpdateValueObject) throw ArgumentError.value(obj);
    final AccountUpdateValueObject(
      :title,
      :type,
      :currencyCode,
      :model,
      :color,
      :balance
    ) = obj;
    final newModel = model.copyWith(
      updated: DateTime.now(),
      title: title ?? model.title,
      type: type ?? model.type,
      currency: FiatCurrency.maybeFromCode(currencyCode) ?? model.currency,
      color: color ?? model.color,
      balance: balance ?? model.balance,
    );
    await _accountRepo.update(dto: _accountFactory.to(newModel));
    return newModel;
  }

  Future<void> delete(String id) async {
    await _accountRepo.delete(id: id);
  }
}
