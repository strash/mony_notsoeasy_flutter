import "dart:math";

import "package:flutter/widgets.dart";
import "package:mony_app/common/extensions/extensions.dart";
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

  List<Map<String, dynamic>> _prepareData() {
    // sort
    data.sort((a, b) => a.compareTo(b));

    // TODO: автоматически добавлять недостающие X айтемы если Y - дата

    // map
    final List<Map<String, dynamic>> list = [];
    for (final item in data) {
      final Object xValue;
      if (item.x is ChartPlottableValue<DateTime>) {
        // TODO: преобразовывать в лейбл
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
      if (idx == -1) {
        final groups = [
          {"value": item.y.numericValue, "groupBy": item.groupBy},
        ];
        list.add({"x": xValue, "y": groups});
      } else {
        final groups = list[idx]["y"] as List<Map<String, dynamic>>;
        final groupIdx = groups.indexWhere((e) => e["groupBy"] == item.groupBy);
        if (groupIdx == -1) {
          groups.add({"value": item.y.numericValue, "groupBy": item.groupBy});
        } else {
          final sum = (groups[groupIdx]["value"] as num) + item.y.numericValue;
          groups[groupIdx]["value"] = sum;
        }
        groups.sort(
          (a, b) => a["groupBy"].hashCode.compareTo(b["groupBy"].hashCode),
        );
        list[idx] = {"x": xValue, "y": groups};
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final data = _prepareData();
    final maxValue = data.fold(
      .0,
      (prev, curr) => max(
        prev,
        (curr["y"] as List<Map<String, dynamic>>)
            .fold(.0, (p, c) => p + (c["value"] as num)),
      ),
    );

    return CustomPaint(
      painter: _Painter(
        config: config,
        data: data,
        maxValue: maxValue,
      ),
    );
  }
}

final class _Painter extends CustomPainter {
  final ChartConfig config;
  // data: [ { x,  y: [ { value, groupBy, groupColor } ] } ]
  final List<Map<String, dynamic>> data;
  final num maxValue;

  _Painter({
    required this.config,
    required this.data,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    print(data);
    final paint = Paint();

    // grid
    paint.strokeWidth = 1.0;
    paint.color = config.gridColor;
    canvas.drawLine(Offset.zero, Offset(size.width, .0), paint);
    canvas.drawLine(
      Offset(.0, size.height),
      Offset(size.width, size.height),
      paint,
    );

    // marks
    paint.strokeWidth = 0;
    final width = size.width / max(1, data.length);
    for (final (index, value) in data.indexed) {
      final y = value["y"] as List<Map<String, dynamic>>;
      double offset = .0;
      for (final group in y) {
        paint.color = config.groupColor(group["groupBy"]);
        final height = group["value"] as num;
        final displayedHeight =
            height.toDouble().remap(.0, maxValue.toDouble(), .0, size.height);
        Rect rect = Rect.fromLTWH(
          index * width,
          .0,
          max(10.0, width - config.padding * 2.0),
          displayedHeight,
        );
        rect = rect.shift(
          Offset(config.padding, size.height - offset - displayedHeight),
        );
        canvas.drawRect(rect, paint);
        offset += displayedHeight;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
