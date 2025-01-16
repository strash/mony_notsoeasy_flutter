import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/settings/components/entry.dart";

class SettingsGroupComponent extends StatelessWidget {
  final List<SettingsEntryComponent> children;

  const SettingsGroupComponent({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: const SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.all(
              SmoothRadius(
                cornerRadius: 15.0,
                cornerSmoothing: 1.0,
              ),
            ),
          ),
        ),
        child: SeparatedComponent.list(
          mainAxisSize: MainAxisSize.min,
          separatorBuilder: (context, index) {
            return SizedBox.fromSize(
              size: const Size.fromHeight(1.0),
              child: ColoredBox(color: theme.colorScheme.surfaceContainer),
            );
          },
          children: children,
        ),
      ),
    );
  }
}
