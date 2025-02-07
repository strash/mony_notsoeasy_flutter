import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start/start.dart";
import "package:mony_app/features/start/use_case/on_button_start_pressed.dart";

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<StartViewModel>();
    final onButtonStartPressed = viewModel<OnButtonStartPressed>();
    final brightness = MediaQuery.platformBrightnessOf(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.secondary
                  .withValues(alpha: brightness == Brightness.light ? .8 : .4),
              theme.colorScheme.surface.withValues(alpha: .1),
            ],
            stops: const [.0, .6],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
                              color: theme.colorScheme.surfaceContainer
                                  .withValues(alpha: .2),
                              shadows: [
                                BoxShadow(
                                  color: theme.colorScheme.secondaryContainer
                                      .withValues(
                                    alpha: brightness == Brightness.light
                                        ? .6
                                        : .3,
                                  ),
                                  blurRadius: 40.0,
                                  blurStyle: BlurStyle.outer,
                                ),
                              ],
                              shape: SmoothRectangleBorder(
                                side: BorderSide(
                                  color: theme.colorScheme.surface,
                                ),
                                borderRadius: const SmoothBorderRadius.all(
                                  SmoothRadius(
                                    cornerRadius: 35.0,
                                    cornerSmoothing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 22.0,
                                  right: 22.0,
                                ),
                                child: Text(
                                  "😉",
                                  style: theme.textTheme.displayLarge,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 35.0),

                      // -> name
                      Text(
                        "Mony",
                        style: GoogleFonts.golosText(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "помнит куда деньги девались",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.golosText(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.onSurfaceVariant,
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, .0, 15.0, 40.0),
                          child: FilledButton(
                            onPressed: () => onButtonStartPressed(context),
                            child: const Text("Супер, дальше!"),
                          ),
                        ),
                      ),
                    ],
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
