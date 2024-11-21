import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start_account/start_account.dart";
import "package:mony_app/gen/assets.gen.dart";

class StartAccountView extends StatelessWidget {
  const StartAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<StartAccountViewModel>();
    final onCreateAccountPressed = viewModel<OnShowAccountFormPressed>();
    final onImportDataPressed = viewModel<OnImportDataPressed>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // -> icon
            const Spacer(),
            Center(
              child: Stack(
                children: [
                  SvgPicture.asset(
                    Assets.icons.widgetSmall,
                    width: 150.0,
                    height: 150.0,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.tertiaryContainer,
                      BlendMode.srcIn,
                    ),
                  ),
                  SvgPicture.asset(
                    Assets.icons.widgetSmallBadgePlus,
                    width: 150.0,
                    height: 150.0,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.secondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // -> text
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, .0, 25.0, 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -> title
                  Text(
                    "Счет",
                    style: GoogleFonts.golosText(
                      fontSize: 20.0,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15.0),

                  // -> description
                  Text(
                    "Для начала нужно завести счет, в который можно "
                    "добавлять новые транзакции. Позже будет возможность "
                    "создать другие счета.\n\nСейчас можно либо создать "
                    "новый счет, либо импортировать свои данные в виде "
                    "CSV файла.",
                    style: GoogleFonts.golosText(
                      fontSize: 15.0,
                      height: 1.3,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // -> buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, .0, 15.0, 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // -> button create account
                  FilledButton(
                    onPressed: () => onCreateAccountPressed(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Создать счет"),
                        const SizedBox(width: 8.0),
                        SvgPicture.asset(
                          Assets.icons.plus,
                          width: 22.0,
                          height: 22.0,
                          colorFilter: ColorFilter.mode(
                            theme.colorScheme.onPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // -> button import data
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.tertiary,
                    ),
                    onPressed: () => onImportDataPressed(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Импорт из CSV",
                          style: GoogleFonts.golosText(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onTertiary,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        SvgPicture.asset(
                          Assets.icons.squareAndArrowDown,
                          width: 22.0,
                          height: 22.0,
                          colorFilter: ColorFilter.mode(
                            theme.colorScheme.onTertiary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
