part of "./theme.dart";

final _filledButtonThemeData = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    elevation: 0.0,
    enableFeedback: true,
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    splashFactory: NoSplash.splashFactory,
    shape: Smooth.border(15.0),
    minimumSize: const Size.square(48.0),
    textStyle: GoogleFonts.golosText(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    ),
  ),
);
