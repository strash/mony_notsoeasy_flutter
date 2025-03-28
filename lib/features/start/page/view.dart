import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start/start.dart";
import "package:mony_app/features/start/use_case/use_case.dart";
import "package:mony_app/i18n/strings.g.dart";

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    final ex = Theme.of(context).extension<ColorExtension>();
    final colorScheme = ColorScheme.of(context);
    final baseColor = ex!.from(EColorName.random()).color;
    final bgColor = Color.lerp(baseColor, colorScheme.surface, .7)!;
    final fgColor = Color.lerp(baseColor, colorScheme.onSurface, .5)!;
    final linkColor = Color.lerp(baseColor, colorScheme.primary, .8)!;
    final colors = [
      baseColor,
      Color.lerp(baseColor, colorScheme.onSurface, .1)!,
    ];

    final viewModel = context.viewModel<StartViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        decoration: BoxDecoration(color: bgColor),
        child: SafeArea(
          child: Column(
            children: [
              // -> app name
              Flexible(
                flex: 5,
                child: SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // -> icon
                      SizedBox(
                        width: 140.0,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              color: colorScheme.surface,
                              shape: Smooth.border(35.0),
                            ),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 18.0,
                                  right: 18.0,
                                ),
                                child: SizedBox.square(
                                  dimension: 60.0,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100.0),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: colors,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),

                      // -> name
                      Text(
                        context.t.features.start.app_name,
                        style: GoogleFonts.golosText(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                          color: fgColor,
                        ),
                      ),
                      Text(
                        context.t.features.start.subtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.golosText(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: fgColor.withValues(alpha: .6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // -> button next
              Flexible(
                flex: 2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, .0, 15.0, 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: linkColor,
                          ),
                          onPressed: () {
                            viewModel<OnButtonStartPressed>()(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                            ),
                            child: Text(context.t.features.start.button_next),
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            viewModel<OnPrivacyPolicyPressed>()(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              context.t.features.start.privacy_policy,
                              style: GoogleFonts.golosText(
                                fontSize: 14.0,
                                color: linkColor,
                                decoration: TextDecoration.underline,
                                decorationColor: linkColor.withValues(
                                  alpha: .6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
