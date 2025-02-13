import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter_rustore_review/flutter_rustore_review.dart";
import "package:mony_app/data/local_storage/local_storage.dart";

final class AppReviewService {
  final _channelName = "strash.mony/review";
  final _methodName = "requestReview";
  final _sharedAttemptsCountKey = "app_review.attempts_to_call_count";

  final _requestThreshold = 3;

  final String? _appFlavor;

  final SharedPreferencesLocalStorageRepository _sharedPrefRepo;

  AppReviewService({
    required SharedPreferencesLocalStorageRepository
    sharedPreferencesRepository,
  }) : _sharedPrefRepo = sharedPreferencesRepository,
       _appFlavor = appFlavor;

  Future<bool> _canRequestReview() async {
    final count = await _sharedPrefRepo.getInt(_sharedAttemptsCountKey);
    if (count == null) {
      await _sharedPrefRepo.setInt(_sharedAttemptsCountKey, 1);
      return false;
    }
    final canRequest = count >= _requestThreshold;
    await _sharedPrefRepo.setInt(
      _sharedAttemptsCountKey,
      canRequest ? 0 : count + 1,
    );
    return canRequest;
  }

  Future<void> requestReview() async {
    final canRequestReview = await _canRequestReview();
    if (!canRequestReview) return;
    await Future.delayed(const Duration(seconds: 1));
    await _makeRequest();
  }

  Future<void> requestImmediateReview() async {
    await _makeRequest();
  }

  Future<void> _makeRequest() async {
    if (_appFlavor == "prod_rustore_flavor") {
      RustoreReviewClient.request().then((value) {
        RustoreReviewClient.review().then(
          (value) {
            if (kDebugMode) print("success review");
          },
          onError: (err) {
            if (kDebugMode) print("onError: $err");
          },
        );
      });
    } else {
      final channel = MethodChannel(_channelName);
      try {
        await channel.invokeMethod<String>(_methodName);
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
  }
}
