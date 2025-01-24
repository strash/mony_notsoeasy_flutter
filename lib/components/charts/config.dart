import "package:flutter/rendering.dart";

final class ChartConfig {
  final Color gridColor;
  final double padding;
  final Color Function(dynamic group) groupColor;

  const ChartConfig({
    required this.gridColor,
    this.padding = 10.0,
    required this.groupColor,
  });
}
