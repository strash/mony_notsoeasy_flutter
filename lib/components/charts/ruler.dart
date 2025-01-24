import "package:flutter/rendering.dart";
import "package:mony_app/components/charts/chart.dart";

final class ChartRulerComponent {
  final ChartPlottableValue threshold;
  final Axis axis;

  ChartRulerComponent({
    required this.threshold,
    this.axis = Axis.horizontal,
  });
}
