import "package:flutter/material.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/gen/assets.gen.dart";

class BackButtonComponent extends StatelessWidget {
  const BackButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarButtonComponent(
      icon: Assets.icons.chevronBackward,
      padding: const EdgeInsets.only(right: 10.0),
      onTap: Navigator.of(context).maybePop<void>,
    );
  }
}
