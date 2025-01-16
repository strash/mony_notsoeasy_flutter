import "package:flutter/material.dart";
import "package:mony_app/data/local_storage/repository/shared_preferences.dart";

final class DomainSharedPrefenecesService {
  final SharedPreferencesLocalStorageRepository _repo;

  final _newTransactionKeyboardHintKey =
      "is_new_transaction_keybord_hint_accepted";
  final _settingsThemeMode = "settings_theme_mode";
  final _settingsCents = "settings_cents";

  DomainSharedPrefenecesService({
    required SharedPreferencesLocalStorageRepository sharedPrefencesRepository,
  }) : _repo = sharedPrefencesRepository;

  // -> transaction

  Future<bool> isNewTransactionKeyboardHintAccepted() async {
    return await _repo.getBool(_newTransactionKeyboardHintKey) ?? false;
  }

  Future<bool> acceptNewTransactionKeyboardHint() async {
    await _repo.setBool(_newTransactionKeyboardHintKey, true);
    return true;
  }

  // -> settings

  Future<ThemeMode> getSettingsThemeMode() async {
    return ThemeMode.values.elementAt(
      await _repo.getInt(_settingsThemeMode) ?? ThemeMode.system.index,
    );
  }

  Future<void> setSettingsThemeMode(ThemeMode value) async {
    await _repo.setInt(_settingsThemeMode, value.index);
  }

  Future<bool> isSettingsCentsVisible() async {
    return await _repo.getBool(_settingsCents) ?? true;
  }

  Future<void> setSettingsCents(bool value) async {
    await _repo.setBool(_settingsCents, value);
  }
}
