import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/constants.dart";
import "package:url_launcher/url_launcher.dart";

final class OnPrivacyPolicyPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final url = Uri.https(kPrivacyPolicyHost, kPrivacyPolicyPath);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    }
  }
}
