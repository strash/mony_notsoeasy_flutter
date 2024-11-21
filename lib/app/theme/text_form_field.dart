part of "./theme.dart";

const _padding = EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0);

final class SmoothInputBorder extends InputBorder {
  final Color color;

  final SmoothRectangleBorder _shape;

  SmoothInputBorder(this.color)
      : _shape = SmoothRectangleBorder(
          side: BorderSide(color: color),
          borderRadius: const SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 15.0, cornerSmoothing: 1.0),
          ),
        );

  @override
  InputBorder copyWith({BorderSide? borderSide}) => SmoothInputBorder(color);

  @override
  EdgeInsetsGeometry get dimensions => _shape.dimensions;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _shape.getInnerPath(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _shape.getOuterPath(rect);
  }

  @override
  bool get isOutline => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    _shape.paint(canvas, rect);
  }

  @override
  ShapeBorder scale(double t) => _shape.scale(t);
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
    return GoogleFonts.golosText(
      color: color,
      fontSize: 16.0,
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
    return GoogleFonts.golosText(
      color: color,
      fontSize: 16.0,
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
    return GoogleFonts.golosText(
      color: color,
      fontSize: 13.0,
      fontWeight: FontWeight.w400,
    );
  });
}

final _lightFormFieldTheme = InputDecorationTheme(
  activeIndicatorBorder: BorderSide(width: 2, color: _lightColorScheme.outline),
  border: SmoothInputBorder(const Color(0x00000000)),
  contentPadding: _padding,
  disabledBorder: SmoothInputBorder(const Color(0x00000000)),
  enabledBorder: SmoothInputBorder(const Color(0x00000000)),
  errorBorder: SmoothInputBorder(_lightColorScheme.error),
  errorMaxLines: 10,
  errorStyle: _labelStyle(_lightColorScheme),
  fillColor: _lightColorScheme.surfaceContainer,
  filled: true,
  floatingLabelBehavior: FloatingLabelBehavior.never,
  floatingLabelStyle: _labelStyle(_lightColorScheme),
  focusedBorder: SmoothInputBorder(_lightColorScheme.secondary),
  focusedErrorBorder: SmoothInputBorder(_lightColorScheme.error),
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
  border: SmoothInputBorder(const Color(0x00000000)),
  contentPadding: _padding,
  disabledBorder: SmoothInputBorder(const Color(0x00000000)),
  enabledBorder: SmoothInputBorder(const Color(0x00000000)),
  errorBorder: SmoothInputBorder(_darkColorScheme.error),
  errorMaxLines: 10,
  errorStyle: _labelStyle(_darkColorScheme),
  fillColor: _darkColorScheme.surfaceContainer,
  filled: true,
  floatingLabelBehavior: FloatingLabelBehavior.never,
  floatingLabelStyle: _labelStyle(_darkColorScheme),
  focusedBorder: SmoothInputBorder(_darkColorScheme.secondary),
  focusedErrorBorder: SmoothInputBorder(_darkColorScheme.error),
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
