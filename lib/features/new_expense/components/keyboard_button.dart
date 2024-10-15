import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/gen/assets.gen.dart";

class SymbolButtonComponent extends StatelessWidget {
  final String symbol;

  const SymbolButtonComponent({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSubmit = symbol == "submit";

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isSubmit
            ? theme.colorScheme.secondary
            : theme.colorScheme.surfaceContainer,
        borderRadius: SmoothBorderRadius.all(
          SmoothRadius(
            cornerRadius: 20.r,
            cornerSmoothing: 1.0,
          ),
        ),
      ),
      child: Center(
        child: isSubmit
            ? SvgPicture.asset(
                Assets.icons.checkmarkSemibold,
                width: 40.r,
                height: 40.r,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.surface,
                  BlendMode.srcIn,
                ),
              )
            : Text(
                symbol,
                style: GoogleFonts.golosText(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface,
                  decoration: TextDecoration.none,
                ),
              ),
      ),
    );
  }
}
