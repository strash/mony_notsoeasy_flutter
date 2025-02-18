import "dart:io" show Platform;

import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/constants.dart";
import "package:url_launcher/url_launcher.dart";

final class OnSupportPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final os = Platform.isAndroid ? "Android" : "iOS";
    final subject = Uri.encodeComponent("Пишу из приложения Mony");
    final body = Uri.encodeComponent("""
----- important info -----
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
