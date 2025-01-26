import "package:flutter/rendering.dart";

final class ChartConfig {
  final Color gridColor;
  final Color gridSecondaryColor;
  final double padding;
  final double radius;
  final Color Function(dynamic group) groupColor;
  final int Function(dynamic a, dynamic b) compareTo;
  final String Function(num value) yFormatter;
  final TextStyle legendStyle;

  const ChartConfig({
    required this.gridColor,
    required this.gridSecondaryColor,
    this.padding = 10.0,
    this.radius = 20.0,
    required this.groupColor,
    required this.compareTo,
    required this.yFormatter,
    required this.legendStyle,
  });
}
