import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/features/new_transaction/components/components.dart";

class NewTransactionSymbolButtonComponent extends StatelessWidget {
  final ButtonType button;
  final String value;

  const NewTransactionSymbolButtonComponent({
    super.key,
    required this.button,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = button.isEnabled(value);

    return AnimatedOpacity(
      opacity: isEnabled ? 1.0 : .3,
      duration: Durations.short4,
      curve: Curves.easeInOut,
      child: AspectRatio(
        aspectRatio: 1.618033,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: button.color,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.all(
                SmoothRadius(cornerRadius: 20.r, cornerSmoothing: 1.0),
              ),
            ),
          ),
          child: Center(
            child: switch (button) {
              final ButtonTypeSymbol button => Text(
                  button.number,
                  style: GoogleFonts.golosText(
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                    decoration: TextDecoration.none,
                  ),
                ),
              final ButtonTypeAction button => SvgPicture.asset(
                  button.icon,
                  width: 36.r,
                  height: 36.r,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.surface,
                    BlendMode.srcIn,
                  ),
                ),
            },
          ),
        ),
      ),
    );
  }
}
