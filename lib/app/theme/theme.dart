import "package:figma_squircle/figma_squircle.dart";
import "package:flex_seed_scheme/flex_seed_scheme.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";

part "./filled_button.dart";

const _primary = Color(0xFF08218A);
const _secondary = Color(0xFF009143);
const _tertiary = Color(0xFF313030);

final lightTheme = ThemeData(
  colorScheme: SeedColorScheme.fromSeeds(
    primaryKey: _primary,
    secondaryKey: _secondary,
    tertiaryKey: _tertiary,
    useExpressiveOnContainerColors: true,
    respectMonochromeSeed: true,
    tones: FlexTones.vividSurfaces(Brightness.light),
  ),
  filledButtonTheme: _filledButtonThemeData,
);

final darkTheme = ThemeData(
  colorScheme: SeedColorScheme.fromSeeds(
    brightness: Brightness.dark,
    primaryKey: _primary,
    secondaryKey: _secondary,
    tertiaryKey: _tertiary,
    useExpressiveOnContainerColors: true,
    respectMonochromeSeed: true,
    tones: FlexTones.vividSurfaces(Brightness.dark),
  ),
  filledButtonTheme: _filledButtonThemeData,
);
