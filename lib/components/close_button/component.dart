import "package:flutter/material.dart";
import "package:mony_app/components/appbar_button/component.dart";
import "package:mony_app/gen/assets.gen.dart";

class CloseButtonComponent extends StatelessWidget {
  const CloseButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return AppBarButtonComponent(
      icon: Assets.icons.xmark,
      padding: const EdgeInsets.only(right: 10.0),
      onTap: navigator.maybePop<void>,
    );
  }
}
