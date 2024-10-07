import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/string.dart";
import "package:mony_app/data/database/repository/repository.dart";
import "package:mony_app/domain/domain.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class AccountService {
  final AccountDatabaseRepository _accountRepo;
  final AccountDatabaseFactoryImpl _accountFactory;

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

  Future<AccountModel?> getOne(String id) async {
    final data = await _accountRepo.getOne(id);
    if (data == null) return null;
    return _accountFactory.from(data);
  }

  Future<AccountModel> create(AccountValueObject obj) async {
    final model = AccountModel(
      id: StringEx.random(20),
      created: DateTime.now(),
      updated: DateTime.now(),
      title: obj.title,
      type: obj.type,
      currency: FiatCurrency.fromCode(obj.currencyCode),
    );
    await _accountRepo.create(_accountFactory.to(model));
    return model;
  }

  Future<void> update(AccountModel model) async {
    await _accountRepo.update(_accountFactory.to(model));
  }

  Future<void> delete(String id) async {
    await _accountRepo.delete(id);
  }
}
