import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:mony_app/data/local_storage/local_storage.dart";

final class AppReviewService {
  final _channelName = "strash.mony/review";
  final _methodName = "requestReview";
  final _sharedAttemptsCountKey = "app_review.attempts_to_call_count";
  final _sharedVersionKey = "app_review.version_with_last_call";

  final _requestThreshold = 10;

  final String _appVersion;

  final SharedPreferencesLocalStorageRepository _sharedPrefRepo;

  AppReviewService({
    required SharedPreferencesLocalStorageRepository
        sharedPreferencesRepository,
  })  : _sharedPrefRepo = sharedPreferencesRepository,
        _appVersion = "${const String.fromEnvironment(
          "BUILD_NAME",
          defaultValue: "1.0.0",
        )}_"
            "${const String.fromEnvironment(
          "BUILD_NUMBER",
          defaultValue: "0",
        )}";

  Future<bool> _canRequestReview() async {
    final count = await _sharedPrefRepo.getInt(_sharedAttemptsCountKey);
    final version = await _sharedPrefRepo.getString(_sharedVersionKey);
    if (count == null || version == null) {
      await _sharedPrefRepo.setInt(_sharedAttemptsCountKey, 0);
      await _sharedPrefRepo.setString(_sharedVersionKey, _appVersion);
      return false;
    }
    final canRequestReview =
        count >= _requestThreshold && version != _appVersion;
    await _sharedPrefRepo.setInt(
      _sharedAttemptsCountKey,
      canRequestReview ? 0 : count + 1,
    );
    await _sharedPrefRepo.setString(_sharedVersionKey, _appVersion);
    return canRequestReview;
  }

  Future<void> requestReview() async {
    final channel = MethodChannel(_channelName);
    try {
      final res = await channel.invokeMethod<String>(_methodName);
      print(res);
    } on PlatformException catch (e) {
      if (kDebugMode) print(e.message);
      rethrow;
    }
  }
}
