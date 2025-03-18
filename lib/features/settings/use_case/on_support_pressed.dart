import "dart:io" show Platform;

import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/i18n/strings.g.dart";
import "package:url_launcher/url_launcher.dart";

final class OnSupportPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final tr = context.t.features.settings.support;
    final os = Platform.isAndroid ? "Android" : "iOS";
    final subject = Uri.encodeComponent(tr.email_subject);
    final body = Uri.encodeComponent("""
----- ${tr.email_body_hint} -----
$os: $kBuildName ($kBuildNumber)

""");
    final uri = Uri(
      scheme: "mailto",
      path: kSupportEmail,
      query: "subject=$subject&body=$body",
    );

    if (await canLaunchUrl(uri)) {
      if (context.mounted) {
        await launchUrl(uri);
      }
    }
  }
}
