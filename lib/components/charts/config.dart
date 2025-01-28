import "package:flutter/rendering.dart";

final class ChartConfig {
  final Color gridColor;
  final Color gridSecondaryColor;
  final Color? medianLineColor;
  final EdgeInsets medianPadding;
  final double medianRadius;
  final double padding;
  final double radius;
  final bool showMedian;
  final Color Function(dynamic group) groupColor;
  final int Function(dynamic a, dynamic b) compareTo;
  final String Function(num value) yFormatter;
  final TextStyle legendStyle;
  final TextStyle? medianStyle;

  const ChartConfig({
    required this.gridColor,
    required this.gridSecondaryColor,
    this.medianLineColor,
    this.medianPadding = const EdgeInsets.fromLTRB(5.0, 1.0, 3.0, 1.0),
    this.medianRadius = 5.0,
    this.padding = 10.0,
    this.radius = 20.0,
    this.showMedian = false,
    required this.groupColor,
    required this.compareTo,
    required this.yFormatter,
    required this.legendStyle,
    this.medianStyle,
  });
}
