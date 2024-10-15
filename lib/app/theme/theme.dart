import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";

part "./app_bar.dart";
part "./colorscheme.dart";
part "./filled_button.dart";
part "./text_form_field.dart";

final lightTheme = ThemeData(
  colorScheme: _lightColorScheme,
  appBarTheme: _lightAppBarTheme,
  filledButtonTheme: _filledButtonThemeData,
  inputDecorationTheme: _lightFormFieldTheme,
);

final darkTheme = ThemeData(
  colorScheme: _darkColorScheme,
  appBarTheme: _darkAppBarTheme,
  filledButtonTheme: _filledButtonThemeData,
  inputDecorationTheme: _darkFormFieldTheme,
);
