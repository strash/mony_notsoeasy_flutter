import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/start_account/start_account.dart";
import "package:mony_app/features/start_account/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class StartAccountView extends StatelessWidget {
  const StartAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final viewModel = context.viewModel<StartAccountViewModel>();

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
                    Assets.icons.widgetSmallHole,
                    width: 150.0,
                    height: 150.0,
                    colorFilter: ColorFilter.mode(
                      colorScheme.tertiaryContainer,
                      BlendMode.srcIn,
                    ),
                  ),
                  SvgPicture.asset(
                    Assets.icons.widgetSmallBadgePlus,
                    width: 150.0,
                    height: 150.0,
                    colorFilter: ColorFilter.mode(
                      colorScheme.secondary,
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
                    context.t.features.start_account.title,
                    style: GoogleFonts.golosText(
                      fontSize: 20.0,
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15.0),

                  // -> description
                  Text(
                    context.t.features.start_account.description,
                    style: GoogleFonts.golosText(
                      fontSize: 15.0,
                      height: 1.3,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // -> buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, .0, 15.0, 40.0),
              child: SeparatedComponent.list(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 15.0);
                },
                children: [
                  // -> button create account
                  FilledButton(
                    onPressed:
                        !viewModel.isImportInProgress
                            ? () =>
                                viewModel<OnShowAccountFormPressed>()(context)
                            : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(context.t.features.start_account.button_create),
                        const SizedBox(width: 8.0),
                        SvgPicture.asset(
                          Assets.icons.plus,
                          width: 22.0,
                          height: 22.0,
                          colorFilter: ColorFilter.mode(
                            colorScheme.onPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SeparatedComponent.list(
                    direction: Axis.horizontal,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 15.0);
                    },
                    children: [
                      // -> button import from mony file
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.tertiary,
                          ),
                          onPressed:
                              !viewModel.isImportInProgress
                                  ? () => viewModel<OnImportMonyDataPressed>()(
                                    context,
                                  )
                                  : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context
                                    .t
                                    .features
                                    .start_account
                                    .button_import_mony,
                                style: GoogleFonts.golosText(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onTertiary,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              SvgPicture.asset(
                                Assets.icons.squareAndArrowDown,
                                width: 22.0,
                                height: 22.0,
                                colorFilter: ColorFilter.mode(
                                  colorScheme.onTertiary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // -> button import from csv
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.tertiary,
                          ),
                          onPressed:
                              !viewModel.isImportInProgress
                                  ? () => viewModel<OnImportCsvDataPressed>()(
                                    context,
                                  )
                                  : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context
                                    .t
                                    .features
                                    .start_account
                                    .button_import_csv,
                                style: GoogleFonts.golosText(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onTertiary,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              SvgPicture.asset(
                                Assets.icons.squareAndArrowDown,
                                width: 22.0,
                                height: 22.0,
                                colorFilter: ColorFilter.mode(
                                  colorScheme.onTertiary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
