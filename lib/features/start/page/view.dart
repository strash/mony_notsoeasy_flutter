import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start/start.dart";
import "package:mony_app/features/start/use_case/use_case.dart";

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
                      style: GoogleFonts.robotoFlex(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      "Mony App",
                      style: GoogleFonts.golosText(
                        fontSize: 40.sp,
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
                        padding: EdgeInsets.fromLTRB(15.w, .0, 15.w, 40.h),
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
