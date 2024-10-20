import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start_account/start_account.dart";
import "package:mony_app/features/start_account/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class StartAccountView extends StatelessWidget {
  const StartAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<StartAccountViewModel>();
    final onCreateAccountPressed = viewModel<OnCreateAccountPressed>();
    final onImportDataPressed = viewModel<OnImportDataPressed>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // -> icon
            const Spacer(),
            Center(
              child: SvgPicture.asset(
                Assets.icons.widgetSmallBadgePlus,
                width: 150.r,
                height: 150.r,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.surfaceContainer,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const Spacer(),

            // -> text
            Padding(
              padding: EdgeInsets.fromLTRB(25.w, .0, 25.w, 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -> title
                  Text(
                    "Счет",
                    style: GoogleFonts.golosText(
                      fontSize: 20.sp,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 15.h),

                  // -> description
                  Text(
                    "Для начала нужно завести счет, в который можно "
                    "добавлять новые транзакции. Позже будет возможность "
                    "создать другие счета.\n\nСейчас можно либо создать "
                    "новый счет, либо импортировать свои данные в виде "
                    "CSV файла.",
                    style: GoogleFonts.robotoFlex(
                      fontSize: 15.sp,
                      height: 1.3.sp,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // -> buttons
            Padding(
              padding: EdgeInsets.fromLTRB(15.w, .0, 15.w, 40.h),
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
                        SizedBox(width: 8.w),
                        SvgPicture.asset(
                          Assets.icons.plus,
                          width: 22.r,
                          height: 22.r,
                          colorFilter: ColorFilter.mode(
                            theme.colorScheme.onPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const RSizedBox(height: 20.0),

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
                          style: GoogleFonts.robotoFlex(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onTertiary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        SvgPicture.asset(
                          Assets.icons.squareAndArrowDown,
                          width: 22.r,
                          height: 22.r,
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
