part of "./theme.dart";

final _padding = EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h);

InputBorder _getBorder(Color color) {
  return OutlineInputBorder(
    gapPadding: 0.0,
    borderSide: BorderSide(color: color),
    borderRadius: SmoothBorderRadius.all(
      SmoothRadius(cornerRadius: 15.r, cornerSmoothing: 1.0),
    ),
  );
}

WidgetStateColor _iconColor(ColorScheme scheme) {
  return WidgetStateColor.resolveWith((Set<WidgetState> state) {
    if (state.contains(WidgetState.disabled)) {
      return scheme.tertiaryContainer;
    }
    return scheme.tertiary;
  });
}

WidgetStateTextStyle _labelStyle(ColorScheme scheme) {
  return WidgetStateTextStyle.resolveWith((Set<WidgetState> state) {
    Color color = scheme.onSurfaceVariant;
    if (state.contains(WidgetState.disabled)) {
      color = scheme.tertiaryContainer;
    } else if (state.contains(WidgetState.focused)) {
      color = scheme.onSurface;
    }
    return GoogleFonts.robotoFlex(
      color: color,
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
    );
  });
}

WidgetStateTextStyle _hintInputStyle(ColorScheme scheme) {
  return WidgetStateTextStyle.resolveWith((Set<WidgetState> state) {
    Color color = scheme.onSurfaceVariant.withOpacity(0.4);
    if (state.contains(WidgetState.disabled)) {
      color = scheme.tertiaryContainer.withOpacity(0.8);
    } else if (state.contains(WidgetState.focused)) {
      color = scheme.onSurfaceVariant.withOpacity(0.6);
    }
    return GoogleFonts.robotoFlex(
      color: color,
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
    );
  });
}

WidgetStateTextStyle _underInputStyle(ColorScheme scheme) {
  return WidgetStateTextStyle.resolveWith((Set<WidgetState> state) {
    Color color = scheme.onSurfaceVariant;
    if (state.contains(WidgetState.disabled)) {
      color = scheme.tertiaryContainer;
    } else if (state.contains(WidgetState.focused)) {
      color = scheme.onSurfaceVariant;
    } else if (state.contains(WidgetState.error)) {
      color = scheme.error;
    }
    return GoogleFonts.robotoFlex(
      color: color,
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
    );
  });
}

final _lightFormFieldTheme = InputDecorationTheme(
  activeIndicatorBorder: BorderSide(width: 2, color: _lightColorScheme.outline),
  border: _getBorder(const Color(0x00000000)),
  contentPadding: _padding,
  disabledBorder: _getBorder(const Color(0x00000000)),
  enabledBorder: _getBorder(const Color(0x00000000)),
  errorBorder: _getBorder(_lightColorScheme.error),
  errorMaxLines: 10,
  errorStyle: _labelStyle(_lightColorScheme),
  fillColor: _lightColorScheme.surfaceContainer,
  filled: true,
  floatingLabelBehavior: FloatingLabelBehavior.never,
  floatingLabelStyle: _labelStyle(_lightColorScheme),
  focusedBorder: _getBorder(_lightColorScheme.primary),
  focusedErrorBorder: _getBorder(_lightColorScheme.error),
  helperMaxLines: 10,
  helperStyle: _underInputStyle(_lightColorScheme),
  hintFadeDuration: Durations.short2,
  hintStyle: _hintInputStyle(_lightColorScheme),
  iconColor: _iconColor(_lightColorScheme),
  isCollapsed: true,
  isDense: true,
  labelStyle: _labelStyle(_lightColorScheme),
  outlineBorder: BorderSide(width: 2, color: _lightColorScheme.outline),
  prefixIconColor: _iconColor(_lightColorScheme),
  prefixStyle: _labelStyle(_lightColorScheme),
  suffixIconColor: _iconColor(_lightColorScheme),
  suffixStyle: _labelStyle(_lightColorScheme),
);

final _darkFormFieldTheme = InputDecorationTheme(
  activeIndicatorBorder: BorderSide(width: 2, color: _darkColorScheme.outline),
  border: _getBorder(const Color(0x00000000)),
  contentPadding: _padding,
  disabledBorder: _getBorder(const Color(0x00000000)),
  enabledBorder: _getBorder(const Color(0x00000000)),
  errorBorder: _getBorder(_darkColorScheme.error),
  errorMaxLines: 10,
  errorStyle: _labelStyle(_darkColorScheme),
  fillColor: _darkColorScheme.surfaceContainer,
  filled: true,
  floatingLabelBehavior: FloatingLabelBehavior.never,
  floatingLabelStyle: _labelStyle(_darkColorScheme),
  focusedBorder: _getBorder(_darkColorScheme.primary),
  focusedErrorBorder: _getBorder(_darkColorScheme.error),
  helperMaxLines: 10,
  helperStyle: _underInputStyle(_darkColorScheme),
  hintFadeDuration: Durations.short2,
  hintStyle: _hintInputStyle(_darkColorScheme),
  iconColor: _iconColor(_darkColorScheme),
  isCollapsed: true,
  isDense: true,
  labelStyle: _labelStyle(_darkColorScheme),
  outlineBorder: BorderSide(width: 2, color: _darkColorScheme.outline),
  prefixIconColor: _iconColor(_darkColorScheme),
  prefixStyle: _labelStyle(_darkColorScheme),
  suffixIconColor: _iconColor(_darkColorScheme),
  suffixStyle: _labelStyle(_darkColorScheme),
);
