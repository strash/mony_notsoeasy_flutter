import "dart:io";

import "package:flutter/material.dart";
import "package:mony_app/i18n/strings.g.dart";

enum EAlertResult { cancel, ok }

sealed class AlertComponet {
  static Future<EAlertResult?> show(
    BuildContext context, {
    Widget? title,
    Widget? description,
  }) {
    ButtonStyle? style;
    if (Platform.isIOS) {
      const transparentColor = Color(0x00FFFFFF);
      style = TextButton.styleFrom(
        elevation: .0,
        splashFactory: NoSplash.splashFactory,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: transparentColor,
        overlayColor: transparentColor,
        surfaceTintColor: transparentColor,
        shape: LinearBorder.none,
      );
    }

    return showAdaptiveDialog<EAlertResult?>(
      context: context,
      builder: (context) {
        final navigator = Navigator.of(context);

        return AlertDialog.adaptive(
          title: title,
          content: description,
          actions: EAlertResult.values
              .map((e) {
                return TextButton(
                  style: style,
                  onPressed: () => navigator.pop<EAlertResult>(e),
                  child: Text(context.t.components.alert.button(context: e)),
                );
              })
              .toList(growable: false),
        );
      },
    );
  }
}
