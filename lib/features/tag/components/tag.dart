import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/i18n/strings.g.dart";

class TagTagComponent extends StatelessWidget {
  final TagModel tag;

  const TagTagComponent({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20.0),

          // -> tag
          Flexible(
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 12.0, cornerSmoothing: 0.6),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 15.0,
                ),
                child: Text(
                  "#${tag.title}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.golosText(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),

          // -> subtitle
          Text(
            context.t.features.tag.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.golosText(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
