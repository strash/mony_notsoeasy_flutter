import "dart:io" show Platform;

import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/components/bottom_sheet/component.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/settings/components/stores_bottom_sheet.dart";
import "package:url_launcher/url_launcher.dart";

final class OnReviewPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    if (Platform.isIOS) {
      final lang =
          PlatformDispatcher.instance.locales.firstOrNull?.languageCode
              .toLowerCase() ??
          "ru";
      // TODO: заменить на реальную ссылку
      final uri = Uri.https(
        "apps.apple.com",
        "$lang/app/chevostik/id1609206459",
        {"action": "write-review"},
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    } else {
      final googleUri = Uri.https("play.google.com", "store/apps/details", {
        "id": "ru.notsoeasy.mony.mony_app",
      });
      if (appFlavor == "prod_rustore_flavor" ||
          appFlavor == "dev_rustore_flavor") {
        // https://rustore.ru/catalog/app/ru.notsoeasy.mony.mony_app
        final rustoreUri = Uri(
          scheme: "rustore",
          host: "apps.rustore.ru",
          path: "app/ru.notsoeasy.mony.mony_app",
        );
        final result = await BottomSheetComponent.show<EReviewStoreItem?>(
          context,
          showDragHandle: false,
          builder: (context, bottom) {
            return SettingsStoresBottomSheetComponent(bottom: bottom);
          },
        );
        if (result == null || !context.mounted) return;
        final uri = switch (result) {
          EReviewStoreItem.google => googleUri,
          EReviewStoreItem.rustore => rustoreUri,
        };
        if (await canLaunchUrl(uri) && context.mounted) {
          await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
        }
      } else {
        if (await canLaunchUrl(googleUri) && context.mounted) {
          await launchUrl(googleUri);
        }
      }
    }
  }
}
