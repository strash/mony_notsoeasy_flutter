import "dart:math";

import "package:intl/intl.dart";

extension DoubleEx on double {
  /// Returns formatted number
  String currency({
    required String name,
    required String? symbol,
    bool showDecimal = true,
  }) {
    final formatter = NumberFormat.currency(
      name: name,
      symbol: symbol,
      decimalDigits: showDecimal ? 2 : 0,
    );
    return formatter.format(this);
  }

  /// Checks if value has a fraction
  ///
  /// Example:
  /// ```dart
  /// final value1 = 123.34
  /// print(value1.hasFraction); // true
  ///
  /// final value2 = 123.0
  /// print(value2.hasFraction); // false
  /// ```
  bool get hasFraction {
    return roundToFraction(0) != this;
  }

  /// Returns rounded double number to a specified number of decimal places.
  ///
  /// Example:
  /// ```dart
  /// double value = 1.23000001;
  /// double roundedValue = value.roundToFraction(2); // 1.23
  /// ```
  double roundToFraction(int length) {
    return double.parse(toStringAsFixed(length));
  }

  /// Returns wrapped value between `min` inclusive and `max` exclusive.
  ///
  /// Example:
  /// ```dart
  /// // will print 0.5
  /// print(8.5.wrapf(0.0, 8.0));
  /// ```
  double wrapf(double min, double max) {
    final range = max - min;
    return range == 0 ? min : min + ((((this - min) % range) + range) % range);
  }

  /// Returns lineary interpolated value.
  ///
  /// - `t` - is the number usually between 0.0 and 1.0
  /// - `a` - is the start value
  /// - `b` - is the end value
  ///
  /// Example:
  /// ```dart
  /// // will print 50.0
  /// print(0.5.lerp(0.0, 100.0));
  /// ```
  double lerp(double a, double b) {
    return (1.0 - this) * a + b * this;
  }

  /// Returns the opposite of the [double.lerp].
  ///
  /// - `t` - is the number
  /// - `a` - is the start value
  /// - `b` - is the end value
  ///
  /// Example:
  /// ```dart
  /// // will print 0.5
  /// print(50.0.lerp(0.0, 100.0));
  /// ```
  double invLerp(double a, double b) {
    return (this - a) / max(1.0, b - a);
  }

  /// Returns remaped value.
  ///
  /// - `t` - is the number
  /// - `imin` - is the start value for `t`
  /// - `imax` - is the end value for `t`
  /// - `omin` - is the start value for remaped value
  /// - `omax` - is the end value for remaped value
  ///
  /// Example:
  /// ```dart
  /// // will print 0.25
  /// // Explanation: if 50.0 is in the middle of 0.0 and 100.0
  /// // then the middle of 0.0 and 0.5 will be 0.25
  /// print(50.0.remap(0.0, 100.0, 0.0, 0.5));
  /// ```
  double remap(double imin, double imax, double omin, double omax) {
    final double inv = invLerp(imin, imax);
    return inv.lerp(omin, omax);
  }
}
