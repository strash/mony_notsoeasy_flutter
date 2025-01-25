import "package:flutter/rendering.dart";

final class ChartConfig {
  final Color gridColor;
  final double padding;
  final double radius;
  final Color Function(dynamic group) groupColor;
  final int Function(dynamic a, dynamic b) compareTo;
  final TextStyle legendStyle;

  const ChartConfig({
    required this.gridColor,
    this.padding = 10.0,
    this.radius = 20.0,
    required this.groupColor,
    required this.compareTo,
    required this.legendStyle,
  });
}
