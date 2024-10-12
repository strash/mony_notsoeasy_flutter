import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";

class StartScreenNewAccountView extends StatelessWidget {
  const StartScreenNewAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    // final viewModel = ViewModel.of<StartScreenViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TODO: добавить логотип
            // -> app name
            Expanded(
              child: SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Добро пожаловать в",
                      style: GoogleFonts.robotoFlex(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      "Mony App",
                      style: GoogleFonts.golosText(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(50.0).r,
                      child: Column(
                        children: [
                          // -> button create account
                          FilledButton(
                            onPressed: () {
                              // viewModel.onButtonStartPressed(context);
                            },
                            child: const Text("Создать счет"),
                          ),

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
