import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/settings/components/entry.dart";

class SettingsGroupComponent extends StatelessWidget {
  final List<SettingsEntryComponent> children;
  final Widget? footer;

  const SettingsGroupComponent({
    super.key,
    required this.children,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -> container
          DecoratedBox(
            decoration: ShapeDecoration(
              color: theme.colorScheme.surfaceContainer,
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
                  child:
                      ColoredBox(color: theme.colorScheme.surfaceContainerLow),
                );
              },
              children: children,
            ),
          ),

          // -> footer
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, .0),
              child: DefaultTextStyle(
                style: GoogleFonts.golosText(
                  fontSize: 13.0,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                child: footer!,
              ),
            ),
        ],
      ),
    );
  }
}
