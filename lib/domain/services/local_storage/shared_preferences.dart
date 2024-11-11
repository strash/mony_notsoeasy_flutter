import "package:mony_app/data/local_storage/repository/shared_preferences.dart";

final class DomainSharedPrefenecesService {
  final SharedPreferencesLocalStorageRepository _repo;

  final _newTransactionKeyboardHintKey =
      "is_new_transaction_keybord_hint_accepted";

  DomainSharedPrefenecesService({
    required SharedPreferencesLocalStorageRepository sharedPrefencesRepository,
  }) : _repo = sharedPrefencesRepository;

  Future<bool> isNewTransactionKeyboardHintAccepted() async {
    return await _repo.getBool(_newTransactionKeyboardHintKey) ?? false;
  }

  Future<bool> setIsNewTransactionKeyboardHintAccepted() async {
    await _repo.setBool(_newTransactionKeyboardHintKey, true);
    return true;
  }
}
