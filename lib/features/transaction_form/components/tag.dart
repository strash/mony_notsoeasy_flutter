import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/figma_squircle.dart";

class TransactionFormTagComponent extends StatelessWidget {
  final WidgetBuilder builder;

  const TransactionFormTagComponent({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          shape: Smooth.border(12.0),
        ),
        child: DefaultTextStyle(
          style: GoogleFonts.golosText(
            fontSize: 16.0,
            height: 1.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onTertiaryContainer,
          ),
          child: builder(context),
        ),
      ),
    );
  }
}
