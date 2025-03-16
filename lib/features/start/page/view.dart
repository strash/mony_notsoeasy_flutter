import "package:figma_squircle_updated/figma_squircle.dart";
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
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final baseColor = ex!.from(EColorName.random()).color;
    final bgColor = Color.lerp(baseColor, theme.colorScheme.surface, .7)!;
    final fgColor = Color.lerp(baseColor, theme.colorScheme.onSurface, .5)!;
    final linkColor = Color.lerp(baseColor, theme.colorScheme.primary, .8)!;

    final viewModel = context.viewModel<StartViewModel>();
    final onButtonStartPressed = viewModel<OnButtonStartPressed>();
    final onPrivacyPolicyPressed = viewModel<OnPrivacyPolicyPressed>();

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
                              color: theme.colorScheme.surface,
                              shape: const SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius.all(
                                  SmoothRadius(
                                    cornerRadius: 35.0,
                                    cornerSmoothing: 0.7,
                                  ),
                                ),
                              ),
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
                                        colors: [
                                          baseColor,
                                          Color.lerp(
                                            baseColor,
                                            theme.colorScheme.onSurface,
                                            .1,
                                          )!,
                                        ],
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
                        "Mony",
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
                          onPressed: () => onButtonStartPressed(context),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.0),
                            child: Text("Супер, дальше!"),
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onPrivacyPolicyPressed(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Политика обработки персональных данных",
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
