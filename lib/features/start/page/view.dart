import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start/start.dart";

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<StartViewModel>();
    final onButtonStartPressed = viewModel<OnButtonStartPressed>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TODO: добавить логотип
            // -> app name
            Flexible(
              child: SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Добро пожаловать в",
                      style: GoogleFonts.golosText(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      "Mony App",
                      style: GoogleFonts.golosText(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -> button next
            Expanded(
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
                          child: const Text("Ок, дальше!"),
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
    );
  }
}
