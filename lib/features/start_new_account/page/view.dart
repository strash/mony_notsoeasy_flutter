import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_new_account/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class StartNewAccountView extends StatelessWidget {
  const StartNewAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<StartNewAccountViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // -> icon
            Flexible(
              child: Center(
                child: SvgPicture.asset(
                  Assets.icons.personCropCircleFillBadgePlus,
                  width: 150.r,
                  height: 150.r,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.surfaceContainerLowest,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15.w, .0, 15.w, 40.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Счет",
                        style: GoogleFonts.golosText(
                          fontSize: 24.sp,
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const RSizedBox(height: 10.0),

                      // -> description
                      Text(
                        "Для начала нужно завести один счет, в который можно "
                        "будет добавлять новые транзакции. После этого "
                        "можно создать и другие счета.\n\nСейчас можно либо "
                        "создать новый счет либо импортировать свои транзакции "
                        "из других приложений.",
                        style: GoogleFonts.robotoFlex(
                          fontSize: 14.sp,
                          height: 1.3.sp,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),

                      // -> button create account
                      FilledButton(
                        onPressed: () {
                          viewModel.onCreateAccountPressed(context);
                        },
                        child: const Text("Создать счет"),
                      ),
                      const RSizedBox(height: 10.0),

                      // -> button import data
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.tertiary,
                        ),
                        onPressed: () {
                          viewModel.onImportDataPressed(context);
                        },
                        child: const Text("Импортировать"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
