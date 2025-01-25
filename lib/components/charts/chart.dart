import "dart:math";

import "package:flutter/widgets.dart";
import "package:intl/intl.dart" as intl_lib;
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/charts/config.dart";
import "package:mony_app/components/charts/mark.dart";
import "package:mony_app/components/charts/ruler.dart";

part "./painter.dart";
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
    final intl = intl_lib.Intl();
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
      final xValue = item.x.value;
      final String xLegend;
      final int idx;
      if (item.x is ChartPlottableValue<DateTime>) {
        final date = (item.x.value as DateTime).startOfDay;
        final x = item.x as _TemporalImpl;
        final formatter = intl.date(
          switch (x.component) {
            EChartTemporalView.year => "MMM",
            EChartTemporalView.month => "d",
            EChartTemporalView.weekday => "E",
          },
        );
        // FIXME: для EChartTemporalView.month отображать не все дни в легеде.
        // пропускать некоторые даты и оставлять например каждые семь дней
        xLegend = formatter.format(date);
        final value = xValue as DateTime;
        idx = list.indexWhere((e) {
          final curr = e["x"] as DateTime;
          if (x.component == EChartTemporalView.year) {
            return curr.year == value.year && curr.month == value.month;
          }
          return curr.isSameDateAs(value);
        });
      } else {
        xLegend = item.x.value.toString();
        idx = list.indexWhere((e) => e["x"] == xValue);
      }
      if (idx == -1) {
        final groups = [
          {"value": item.y.numericValue, "groupBy": item.groupBy},
        ];
        list.add({"x": xValue, "xLegend": xLegend, "y": groups});
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
        groups.sort((a, b) => config.compareTo(a["groupBy"], b["groupBy"]));
        list[idx] = {"x": xValue, "xLegend": xLegend, "y": groups};
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final data = _prepareData(context);
    // TODO: округлять значение
    final maxValue = data.fold(.0, (prev, curr) {
      final y = curr["y"] as List<Map<String, dynamic>>;
      return max(
        prev,
        y.fold(.0, (yPrev, yCurr) => yPrev + (yCurr["value"] as num)),
      );
    });

    return CustomPaint(
      painter: _Painter(
        config: config,
        data: data,
        maxValue: maxValue,
      ),
    );
  }
}
