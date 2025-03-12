import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/domain/models/tag.dart";

class TagTagComponent extends StatelessWidget {
  final TagModel tag;

  const TagTagComponent({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20.0),

          // -> tag
          DecoratedBox(
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
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: NumericText(
                "#${tag.title}",
                style: GoogleFonts.golosText(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),

          // -> subtitle
          Text(
            "Тег",
            textAlign: TextAlign.center,
            style: GoogleFonts.golosText(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
