import "package:mony_app/components/charts/chart.dart";
import "package:mony_app/components/charts/enums.dart" show EChartMark;

abstract base class ChartMarkComponent {
  EChartMark get type;
  ChartPlottableValue get x;
  ChartPlottableValue get y;
  Object? get groupBy;

  int compareTo(covariant ChartMarkComponent other);

  static ChartMarkComponent bar({
    required ChartPlottableValue x,
    required ChartPlottableValue y,
    Object? groupBy,
  }) {
    return _BarMark(type: EChartMark.bar, x: x, y: y, groupBy: groupBy);
  }
}

final class _BarMark implements ChartMarkComponent {
  @override
  final EChartMark type;
  @override
  final ChartPlottableValue x;
  @override
  final ChartPlottableValue y;
  @override
  final Object? groupBy;

  _BarMark({
    required this.type,
    required this.x,
    required this.y,
    this.groupBy,
  });

  @override
  int compareTo(_BarMark other) {
    return x.compareTo(other.x);
  }

  @override
  String toString() {
    return "\ntype: $type, x: $x, y: $y, groupBy: $groupBy.";
  }
}
