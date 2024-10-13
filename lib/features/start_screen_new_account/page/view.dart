import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_screen_new_account/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class StartScreenNewAccountView extends StatelessWidget {
  const StartScreenNewAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<StartScreenNewAccountViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // -> app name
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  Assets.icons.personCropCircleFillBadgePlus,
                  width: 100.r,
                  height: 100.r,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.tertiary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(50.0).r,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // -> button create account
                      FilledButton(
                        onPressed: () {
                          // viewModel.onButtonStartPressed(context);
                        },
                        child: const Text("Создать счет"),
                      ),
                      const RSizedBox(height: 20.0),

                      // -> button import data
                      FilledButton(
                        onPressed: () {
                          // viewModel.onButtonStartPressed(context);
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
