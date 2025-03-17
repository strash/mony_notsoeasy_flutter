import "package:flutter/material.dart";
import "package:mony_app/data/local_storage/repository/shared_preferences.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/features/settings/page/view_model.dart"
    show ESettingsLanguage;

final class DomainSharedPreferencesService {
  final SharedPreferencesLocalStorageRepository _repo;

  final _newTransactionKeyboardHintKey =
      "is_new_transaction_keybord_hint_accepted";
  final _settingsThemeMode = "settings_theme_mode";
  final _settingsColors = "settings_colors";
  final _settingsCents = "settings_cents";
  final _settingsTags = "settings_tags";
  final _settingsDefaultTransactionType = "sttings_default_transaction_type";
  final _settingsConfirmTransaction = "setting_confirm_transaction";
  final _settingsConfirmAccount = "settings_confirm_account";
  final _settingsConfirmCategory = "settings_confirm_category";
  final _settingsConfirmTag = "settings_confirm_tag";
  final _settingsLanguage = "settings_language";

  DomainSharedPreferencesService({
    required SharedPreferencesLocalStorageRepository sharedPrefencesRepository,
  }) : _repo = sharedPrefencesRepository;

  // -> transaction

  Future<bool> isNewTransactionKeyboardHintAccepted() async {
    return await _repo.getBool(_newTransactionKeyboardHintKey) ?? false;
  }

  Future<void> setNewTransactionKeyboardHint(bool value) async {
    await _repo.setBool(_newTransactionKeyboardHintKey, value);
  }

  @Deprecated("Use [setNewTransactionKeyboardHint] instead")
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

  Future<bool> isSettingsColorsVisible() async {
    return await _repo.getBool(_settingsColors) ?? true;
  }

  Future<void> setSettingsColors(bool value) async {
    await _repo.setBool(_settingsColors, value);
  }

  Future<bool> isSettingsCentsVisible() async {
    return await _repo.getBool(_settingsCents) ?? true;
  }

  Future<void> setSettingsCents(bool value) async {
    await _repo.setBool(_settingsCents, value);
  }

  Future<bool> isSettingsTagsVisible() async {
    return await _repo.getBool(_settingsTags) ?? true;
  }

  Future<void> setSettingsTagsVisibility(bool value) async {
    await _repo.setBool(_settingsTags, value);
  }

  Future<ETransactionType> getSettingsDefaultTransactionType() async {
    final value =
        await _repo.getString(_settingsDefaultTransactionType) ??
        ETransactionType.defaultValue.value;
    return ETransactionType.from(value);
  }

  Future<void> setSettingsDefaultTransactionType(ETransactionType value) async {
    await _repo.setString(_settingsDefaultTransactionType, value.value);
  }

  Future<bool> getSettingsConfirmTransaction() async {
    return await _repo.getBool(_settingsConfirmTransaction) ?? true;
  }

  Future<void> setSettingsConfirmTransaction(bool value) async {
    await _repo.setBool(_settingsConfirmTransaction, value);
  }

  Future<bool> getSettingsConfirmAccount() async {
    return await _repo.getBool(_settingsConfirmAccount) ?? true;
  }

  Future<void> setSettingsConfirmAccount(bool value) async {
    await _repo.setBool(_settingsConfirmAccount, value);
  }

  Future<bool> getSettingsConfirmCategory() async {
    return await _repo.getBool(_settingsConfirmCategory) ?? true;
  }

  Future<void> setSettingsConfirmCategory(bool value) async {
    await _repo.setBool(_settingsConfirmCategory, value);
  }

  Future<bool> getSettingsConfirmTag() async {
    return await _repo.getBool(_settingsConfirmTag) ?? true;
  }

  Future<void> setSettingsConfirmTag(bool value) async {
    await _repo.setBool(_settingsConfirmTag, value);
  }

  Future<ESettingsLanguage> getSettingsLanguage() async {
    final value =
        await _repo.getString(_settingsLanguage) ??
        ESettingsLanguage.defaultValue.value;
    return ESettingsLanguage.from(value);
  }

  Future<void> setSettingsLanguage(ESettingsLanguage value) async {
    await _repo.setString(_settingsLanguage, value.value);
  }
}
