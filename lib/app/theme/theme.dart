import "dart:math";

import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/figma_squircle.dart";

part "theme.freezed.dart";

part "./app_bar.dart";
part "./colorscheme.dart";
part "./color_extension.dart";
part "./filled_button.dart";
part "./text_form_field.dart";

final lightTheme = ThemeData(
  colorScheme: _lightColorScheme,
  appBarTheme: _lightAppBarTheme,
  filledButtonTheme: _filledButtonThemeData,
  inputDecorationTheme: _lightFormFieldTheme,
  extensions: [lightColorEx],
);

final darkTheme = ThemeData(
  colorScheme: _darkColorScheme,
  appBarTheme: _darkAppBarTheme,
  filledButtonTheme: _filledButtonThemeData,
  inputDecorationTheme: _darkFormFieldTheme,
  extensions: [darkColorEx],
);
