import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/figma_squircle.dart";
import "package:mony_app/domain/models/account.dart" show AccountModel;
import "package:mony_app/i18n/strings.g.dart";

class AccountIconComponent extends StatelessWidget {
  final AccountModel account;
  final bool showColors;

  const AccountIconComponent({
    super.key,
    required this.account,
    required this.showColors,
  });

  @override
  Widget build(BuildContext context) {
    final ex = Theme.of(context).extension<ColorExtension>();
    final colorScheme = ColorScheme.of(context);
    final color = ex?.from(account.colorName).color ?? colorScheme.onSurface;
    final color2 = Color.lerp(color, const Color(0xFFFFFFFF), .3)!;
    final colors = [
      colorScheme.surfaceContainerHighest,
      colorScheme.surfaceContainer,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -> icon
        Center(
          child: SizedBox.square(
            dimension: 100.0,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: showColors ? [color2, color] : colors,
                ),
                shape: Smooth.border(
                  46.0,
                  showColors
                      ? BorderSide.none
                      : BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              child: Center(
                child: Text(
                  account.type.icon,
                  style: TextTheme.of(context).displayLarge,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),

        // -> title
        Text(
          account.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.golosText(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: showColors ? color : colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2.0),

        // -> type
        Text(
          context.t.models.account.type_description(context: account.type),
          textAlign: TextAlign.center,
          style: GoogleFonts.golosText(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
