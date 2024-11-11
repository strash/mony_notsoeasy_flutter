import "package:shared_preferences/shared_preferences.dart";

abstract base class SharedPreferencesLocalStorageRepository {
  const factory SharedPreferencesLocalStorageRepository({
    required SharedPreferencesAsync preferences,
  }) = _Impl;

  Future<int?> getInt(String key);

  Future<double?> getDouble(String key);

  Future<String?> getString(String key);

  Future<bool?> getBool(String key);

  Future<List<String>?> getStrings(String key);

  Future<void> setInt(String key, int value);

  Future<void> setDouble(String key, double value);

  Future<void> setString(String key, String value);

  Future<void> setBool(String key, bool value);

  Future<void> setStrings(String key, List<String> value);
}

final class _Impl implements SharedPreferencesLocalStorageRepository {
  final SharedPreferencesAsync _pref;

  const _Impl({
    required SharedPreferencesAsync preferences,
  }) : _pref = preferences;

  @override
  Future<int?> getInt(String key) async {
    return _pref.getInt(key);
  }

  @override
  Future<double?> getDouble(String key) {
    return _pref.getDouble(key);
  }

  @override
  Future<String?> getString(String key) {
    return _pref.getString(key);
  }

  @override
  Future<bool?> getBool(String key) {
    return _pref.getBool(key);
  }

  @override
  Future<List<String>?> getStrings(String key) {
    return _pref.getStringList(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    return await _pref.setInt(key, value);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    return await _pref.setDouble(key, value);
  }

  @override
  Future<void> setString(String key, String value) async {
    return await _pref.setString(key, value);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    return await _pref.setBool(key, value);
  }

  @override
  Future<void> setStrings(String key, List<String> value) async {
    return await _pref.setStringList(key, value);
  }
}
