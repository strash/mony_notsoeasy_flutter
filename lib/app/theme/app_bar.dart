part of "./theme.dart";

final _lightAppBarTheme = AppBarTheme(
  elevation: 0.0,
  scrolledUnderElevation: 0.0,
  backgroundColor: _lightColorScheme.surface,
  foregroundColor: _lightColorScheme.onSurface,
  surfaceTintColor: const Color(0x00000000),
  shadowColor: const Color(0x00000000),
  centerTitle: true,
  titleTextStyle: GoogleFonts.golosText(
    fontSize: 20.0,
    height: 1.0,
    letterSpacing: -0.1,
    fontWeight: FontWeight.w500,
    color: _lightColorScheme.onSurface,
  ),
);

final _darkAppBarTheme = AppBarTheme(
  elevation: 0.0,
  scrolledUnderElevation: 0.0,
  backgroundColor: _darkColorScheme.surface,
  foregroundColor: _darkColorScheme.onSurface,
  surfaceTintColor: const Color(0x00000000),
  shadowColor: const Color(0x00000000),
  centerTitle: true,
  titleTextStyle: GoogleFonts.golosText(
    fontSize: 20.0,
    height: 1.0,
    letterSpacing: -0.1,
    fontWeight: FontWeight.w500,
    color: _darkColorScheme.onSurface,
  ),
);
