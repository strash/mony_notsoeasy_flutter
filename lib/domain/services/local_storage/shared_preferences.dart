import "package:flutter/material.dart";
import "package:mony_app/data/local_storage/repository/shared_preferences.dart";

final class DomainSharedPrefenecesService {
  final SharedPreferencesLocalStorageRepository _repo;

  final _newTransactionKeyboardHintKey =
      "is_new_transaction_keybord_hint_accepted";
  final _settingsThemeMode = "settings_theme_mode";

  DomainSharedPrefenecesService({
    required SharedPreferencesLocalStorageRepository sharedPrefencesRepository,
  }) : _repo = sharedPrefencesRepository;

  // -> transaction

  Future<bool> isNewTransactionKeyboardHintAccepted() async {
    return await _repo.getBool(_newTransactionKeyboardHintKey) ?? false;
  }

  Future<bool> setIsNewTransactionKeyboardHintAccepted() async {
    await _repo.setBool(_newTransactionKeyboardHintKey, true);
    return true;
  }

  // -> settings

  Future<ThemeMode> getSettingsThemeMode() async {
    return ThemeMode.values.elementAt(
      await _repo.getInt(_settingsThemeMode) ?? ThemeMode.system.index,
    );
  }

  Future<void> setSettingsThemeMode(ThemeMode mode) async {
    await _repo.setInt(_settingsThemeMode, mode.index);
  }
}
