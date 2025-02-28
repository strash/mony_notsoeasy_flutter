import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class BalanceExchangeFormHelperTextComponent extends StatelessWidget {
  final String text;

  const BalanceExchangeFormHelperTextComponent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: GoogleFonts.golosText(
        color: theme.colorScheme.onSurfaceVariant,
        fontSize: 13.0,
        height: 1.2,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
