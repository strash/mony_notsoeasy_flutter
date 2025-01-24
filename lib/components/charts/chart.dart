import "dart:math";

import "package:flutter/material.dart";
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

  List<Map<String, dynamic>> _prepareData(BuildContext context) {
    final loc = MaterialLocalizations.of(context);
    // sort items
    data.sort((a, b) => a.compareTo(b));

    // TODO: автоматически добавлять недостающие Y айтемы если Y - дата
    if (data.firstOrNull is ChartPlottableValue<DateTime>) {
      final iter = data.iterator;
      DateTime? prevValue;
      while (iter.moveNext()) {
        final value = iter.current.y.value as DateTime;
        if (prevValue != null && prevValue.isSameDateAs(value)) {
          continue;
        }
        // FIXME: theres nothing going on right now
        prevValue = value;
      }
    }

    // map
    final List<Map<String, dynamic>> list = [];
    for (final item in data) {
      final Object xValue;
      if (item.x is ChartPlottableValue<DateTime>) {
        // TODO: преобразовывать в лейбл
        final date = (item.x.value as DateTime).startOfDay;
        xValue = switch ((item.x as _TemporalImpl).component) {
          EChartTemporalComponent.month => date.month,
          EChartTemporalComponent.year => date.year,
          EChartTemporalComponent.weekday => date.weekDayIndex(loc),
          EChartTemporalComponent.date => date,
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
        // sort groups
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
    final data = _prepareData(context);
    // TODO: округлять значение
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
        maxValue: maxValue + 2,
      ),
    );
  }
}

final class _Painter extends CustomPainter {
  final ChartConfig config;
  // data: [ { x,  y: [ { value, groupBy } ] } ]
  final List<Map<String, dynamic>> data;
  final num maxValue;

  _Painter({
    required this.config,
    required this.data,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // marks
    paint.strokeWidth = 0;
    final sectionWidth = size.width / max(1, data.length);
    final width = max(10.0, sectionWidth - config.padding * 2.0);
    double barMaxHeight = size.height;
    for (final (index, value) in data.indexed) {
      final y = value["y"] as List<Map<String, dynamic>>;

      // legend
      final left = index * sectionWidth;
      final legend = TextSpan(
        text: value["x"].toString(),
        style: config.legendStyle,
      );
      final legendPainter = TextPainter(
        text: legend,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      legendPainter.layout(minWidth: sectionWidth, maxWidth: sectionWidth);
      final legendSize = legendPainter.size;
      legendPainter.paint(
        canvas,
        Offset(left, size.height - legendSize.height),
      );

      canvas.save();

      // mask for mark groups
      barMaxHeight = size.height - legendSize.height - 5.0;
      final totalHeight =
          y.fold(.0, (prev, curr) => prev + (curr["value"] as num));
      final totalDisplayedHeight =
          totalHeight.remap(.0, maxValue.toDouble(), .0, barMaxHeight);
      Path clipPath = Path()
        ..moveTo(left, config.radius) // top left
        ..arcToPoint(
          Offset(left + config.radius, .0),
          radius: Radius.circular(config.radius),
        ) // top left radius
        ..lineTo(left + width - config.radius, .0) // top right
        ..arcToPoint(
          Offset(left + width, config.radius),
          radius: Radius.circular(config.radius),
        ) // top right radius
        ..lineTo(left + width, totalDisplayedHeight) // bottom right
        ..lineTo(left, totalDisplayedHeight) // bottom left
        ..close();
      // invert by vertical and offset to the right
      clipPath = clipPath.shift(
        Offset(config.padding, barMaxHeight - totalDisplayedHeight),
      );
      canvas.clipPath(clipPath);

      // mark groups
      double offset = .0;
      for (final group in y) {
        paint.color = config.groupColor(group["groupBy"]);
        final height = group["value"] as num;
        final displayedHeight =
            height.toDouble().remap(.0, maxValue.toDouble(), .0, barMaxHeight);
        Rect rect = Rect.fromLTWH(left, .0, width, displayedHeight);
        // invert by vertical and offset to the right
        rect = rect.shift(
          Offset(config.padding, barMaxHeight - offset - displayedHeight),
        );
        canvas.drawRect(rect, paint);
        offset += displayedHeight;
      }

      canvas.restore();

      legendPainter.dispose();
    }

    // grid
    paint.strokeWidth = 1.0;
    paint.color = config.gridColor;
    // top line
    canvas.drawLine(Offset.zero, Offset(size.width, .0), paint);
    // bottom line
    canvas.drawLine(
      Offset(.0, barMaxHeight),
      Offset(size.width, barMaxHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return data != oldDelegate.data ||
        config != oldDelegate.config ||
        maxValue != oldDelegate.maxValue;
  }
}
