part of "./theme.dart";

final _filledButtonThemeData = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    elevation: 0.0,
    enableFeedback: true,
    padding: const EdgeInsets.symmetric(
      horizontal: 20.0,
    ).w,
    splashFactory: NoSplash.splashFactory,
    shape: SmoothRectangleBorder(
      borderRadius: SmoothBorderRadius.all(
        SmoothRadius(
          cornerRadius: 15.r,
          cornerSmoothing: 1.0,
        ),
      ),
    ),
    minimumSize: Size.square(48.r),
    textStyle: GoogleFonts.robotoFlex(
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
    ),
  ),
);