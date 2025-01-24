import "package:flutter/widgets.dart";
import "package:mony_app/components/charts/config.dart";
import "package:mony_app/components/charts/mark.dart";
import "package:mony_app/components/charts/ruler.dart";

part "./plottable.dart";

final class ChartComponent extends StatelessWidget {
  final List<ChartMarkComponent> data;
  final List<ChartRulerComponent> rulers;
  final ChartConfig config;

  ChartComponent({
    super.key,
    required this.data,
    this.rulers = const [],
    required this.config,
  })  : assert(
          EChartMark.values.every((mark) => data.every((e) => e.type == mark)),
          "every mark should be the same EChartMark type",
        ),
        assert(
          data.every((e) => e.x is ChartPlottableValue<num>) ||
              data.every((e) => e.x is ChartPlottableValue<DateTime>) ||
              data.every((e) => e.x is ChartPlottableValue<String>),
          "every X should be the same plottable type",
        ),
        assert(
          (data.every((e) => e.y is ChartPlottableValue<num>) ||
              data.every((e) => e.y is ChartPlottableValue<DateTime>) ||
              data.every((e) => e.y is ChartPlottableValue<String>)),
          "every Y should be the same plottable type",
        ),
        assert(
          data.every((e) => e.groupBy == null) ||
              data.every((e) => e.groupBy is Object),
          "every groupBy should be the same type or null",
        );

  void _prepareData() {
    // sort
    data.sort((a, b) => a.compareTo(b));

    // TODO: автоматически добавлять недостающие X айтемы если Y - дата

    // TODO: items: [ x: group: [ y ] ], maxY
    // map
    final List<Map<String, dynamic>> list = [];
    for (final item in data) {
      final Object xValue;
      if (item.x is ChartPlottableValue<DateTime>) {
        xValue = switch ((item.x as _TemporalImpl).component) {
          EChartTemporalComponent.day => (item.x.value as DateTime).day,
          EChartTemporalComponent.month => (item.x.value as DateTime).month,
          EChartTemporalComponent.year => (item.x.value as DateTime).year,
          EChartTemporalComponent.weekday => (item.x.value as DateTime).weekday,
          EChartTemporalComponent.date => item.x.value,
        };
      } else {
        xValue = item.x.value;
      }
      final idx = list.indexWhere((e) => e["x"] == xValue);
      // TODO: переделать структуру - сразу группировать значения
      if (idx != -1) {
        list[idx] = {
          "x": xValue,
          "y": (list[idx]["y"] as List<Map<String, dynamic>>)
            ..add({"value": item.y, "groupBy": item.groupBy}),
        };
      } else {
        list.add({
          "x": xValue,
          "y": [
            {"value": item.y, "groupBy": item.groupBy},
          ],
        });
      }
    }
    print(list);
  }

  @override
  Widget build(BuildContext context) {
    _prepareData();

    return CustomPaint(
      painter: _Painter(
        config: config,
      ),
    );
  }
}

final class _Painter extends CustomPainter {
  final ChartConfig config;

  _Painter({required this.config});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.strokeWidth = 1.0;
    paint.color = config.gridColor;
    canvas.drawLine(Offset.zero, Offset(size.width, .0), paint);
    canvas.drawLine(
      Offset(.0, size.height),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
