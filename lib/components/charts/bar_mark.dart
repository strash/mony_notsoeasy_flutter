import "package:mony_app/components/charts/plottable.dart";

final class ChartBarMarkComponent {
  final ChartPlottableValue x;
  final ChartPlottableValue y;
  final ChartPlottableValue? groupBy;

  ChartBarMarkComponent({
    required this.x,
    required this.y,
    this.groupBy,
  });
}
