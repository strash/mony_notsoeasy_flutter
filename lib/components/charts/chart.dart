import "dart:math";

import "package:flutter/material.dart";
import "package:intl/intl.dart" as intl;
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/charts/config.dart";
import "package:mony_app/components/charts/mark.dart";

part "./painter.dart";
part "./plottable.dart";

final class ChartComponent extends StatelessWidget {
  final List<ChartMarkComponent> data;
  final ChartConfig config;

  ChartComponent({
    super.key,
    required this.data,
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
        ),
        assert(
          config.showMedian == false ||
              config.showMedian == true &&
                  config.medianLineColor != null &&
                  config.medianStyle != null,
          "to show median provide medianColor and medianStyle",
        );

  List<Map<String, dynamic>> _prepareData(BuildContext context) {
    final loc = MaterialLocalizations.of(context);

    // map
    List<Map<String, dynamic>> list = [];

    if (data.firstOrNull?.x is ChartPlottableValue<DateTime>) {
      final List<DateTime> dates;
      final EChartTemporalView temporalView;
      final intl.DateFormat formatter;
      {
        final x = data.first.x as _TemporalImpl;
        temporalView = x.component;
        switch (temporalView) {
          case EChartTemporalView.year:
            dates = x.value.monthsOfYear();
            formatter = intl.DateFormat("MMM");
          case EChartTemporalView.month:
            dates = x.value.daysOfMonth();
            formatter = intl.DateFormat("d");
          case EChartTemporalView.week:
            dates = x.value.daysOfWeek(loc);
            formatter = intl.DateFormat("E");
        }
      }
      list = List.filled(dates.length, {});
      for (final item in data) {
        final x = item.x as ChartPlottableValue<DateTime>;
        for (final (dateIndex, date) in dates.indexed) {
          final sameDate = switch (temporalView) {
            EChartTemporalView.year => x.value.isSameMonthAs(date),
            _ => x.value.isSameDateAs(date),
          };
          if (!sameDate) continue;
          final listItem = list.elementAt(dateIndex);
          if (listItem.isEmpty) {
            final groups = [
              {"value": item.y.numericValue, "groupBy": item.groupBy},
            ];
            list[dateIndex] = {"x": date, "y": groups};
          } else {
            listItem["y"] = _updateGroup(mark: item, listItem: listItem);
            list[dateIndex] = Map.from(listItem);
          }
          break;
        }
      }
      // set legends
      for (final (index, date) in dates.indexed) {
        final listItem = list.elementAt(index);
        listItem["xLegend"] = formatter.format(date);
        if (temporalView == EChartTemporalView.month &&
            (index % 5 != 0 && index != 0 && index + 1 < list.length)) {
          listItem["xLegend"] = "";
        }
        list[index] = Map.from(listItem);
      }
    } else {
      data.sort((a, b) => a.compareTo(b));
      for (final item in data) {
        final value = item.x.value;
        final legend = item.x.value.toString();
        final idx = list.indexWhere((e) => e["x"] == value);
        if (idx == -1) {
          final groups = [
            {"value": item.y.numericValue, "groupBy": item.groupBy},
          ];
          list.add({"x": value, "xLegend": legend, "y": groups});
        } else {
          final listItem = list[idx];
          listItem["y"] = _updateGroup(mark: item, listItem: listItem);
          list[idx] = Map.from(listItem);
        }
      }
    }
    return list;
  }

  List<Map<String, dynamic>> _updateGroup({
    required ChartMarkComponent mark,
    required Map<String, dynamic> listItem,
  }) {
    final groups = listItem["y"] as List<Map<String, dynamic>>;
    final groupIdx = groups.indexWhere((e) => e["groupBy"] == mark.groupBy);
    if (groupIdx == -1) {
      groups.add({"value": mark.y.numericValue, "groupBy": mark.groupBy});
    } else {
      final groupValue = groups[groupIdx]["value"] as num;
      groups[groupIdx]["value"] = groupValue + mark.y.numericValue;
    }
    // sort groups
    groups.sort((a, b) => config.compareTo(a["groupBy"], b["groupBy"]));
    return groups;
  }

  double _maxValue(List<Map<String, dynamic>> data) {
    final maxValue = data.fold(.0, (prev, curr) {
      final y = curr["y"] as List<Map<String, dynamic>>?;
      if (y == null) return prev;
      return max(
        prev,
        y.fold(.0, (yPrev, yCurr) => yPrev + (yCurr["value"] as num)),
      );
    });
    final ref = maxValue / 100;
    int mod = 1;
    while (mod < ref) {
      mod *= 10;
    }
    mod = max(mod, 10);
    final rem = maxValue % mod;
    final mul = (maxValue - rem) / mod;
    return mul * mod + mod;
  }

  @override
  Widget build(BuildContext context) {
    final data = _prepareData(context);
    final value = _maxValue(data);

    return CustomPaint(
      painter: _Painter(
        config: config,
        data: data,
        maxValue: value,
      ),
    );
  }
}

extension on DateTime {
  bool isSameMonthAs(DateTime other) {
    return year == other.year && month == other.month;
  }
}
