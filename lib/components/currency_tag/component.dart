import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/figma_squircle.dart";

class CurrencyTagComponent extends StatelessWidget {
  final String code;
  final Color? background;
  final Color? foreground;

  const CurrencyTagComponent({
    super.key,
    required this.code,
    this.background,
    this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: background ?? theme.colorScheme.tertiaryContainer,
        shape: Smooth.border(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 3.0),
        child: Text(
          code,
          style: GoogleFonts.golosText(
            fontSize: 10.0,
            height: 1.0,
            fontWeight: FontWeight.w600,
            color: foreground ?? theme.colorScheme.onTertiaryContainer,
            textStyle: theme.textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
