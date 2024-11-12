import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/features/new_transaction/components/components.dart";

class NewTransactionSymbolButtonComponent extends StatelessWidget {
  final ButtonType button;
  final String value;
  final UseCase<Future<void>, ButtonType> onTap;

  const NewTransactionSymbolButtonComponent({
    super.key,
    required this.button,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = button.isEnabled(value);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isEnabled ? () => onTap(context, button) : null,
      child: AspectRatio(
        aspectRatio: 1.618033,
        child: TweenAnimationBuilder<Color?>(
          duration: Durations.short4,
          curve: Curves.easeInOut,
          tween: ColorTween(
            begin: button.color,
            end: isEnabled
                ? button.color
                : theme.colorScheme.surfaceContainer.withOpacity(.8),
          ),
          child: Center(
            child: AnimatedOpacity(
              opacity: isEnabled ? 1.0 : .5,
              duration: Durations.short4,
              curve: Curves.easeInOut,
              child: switch (button) {
                final ButtonTypeSymbol button => Text(
                    button.value,
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
          builder: (context, color, child) {
            return DecoratedBox(
              decoration: ShapeDecoration(
                color: color,
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 20.r, cornerSmoothing: 1.0),
                  ),
                ),
              ),
              child: child,
            );
          },
        ),
      ),
    );
  }
}
