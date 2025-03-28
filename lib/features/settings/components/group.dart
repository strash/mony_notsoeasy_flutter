import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/figma_squircle.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/settings/components/entry.dart";

class SettingsGroupComponent extends StatelessWidget {
  final Widget? header;
  final Widget? footer;
  final Color? background;
  final List<SettingsEntryComponent> children;

  const SettingsGroupComponent({
    super.key,
    this.header,
    this.footer,
    this.background,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -> header
          if (header != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DefaultTextStyle(
                style: GoogleFonts.golosText(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
                child: header!,
              ),
            ),

          // -> container
          DecoratedBox(
            decoration: ShapeDecoration(
              color: background ?? colorScheme.surfaceContainer,
              shape: Smooth.border(15.0),
            ),
            child: SeparatedComponent.list(
              mainAxisSize: MainAxisSize.min,
              separatorBuilder: (context, index) {
                return SizedBox.fromSize(
                  size: const Size.fromHeight(1.0),
                  child: ColoredBox(color: colorScheme.surfaceContainerLow),
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
                  color: colorScheme.onSurfaceVariant,
                ),
                child: footer!,
              ),
            ),
        ],
      ),
    );
  }
}
