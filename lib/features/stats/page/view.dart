import "package:flutter/material.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/charts/component.dart";

enum _ETestCategory { one, two, three }

final class _TestValue {
  final double value;
  final DateTime date;
  final _ETestCategory category;

  _TestValue({required this.value, required this.date, required this.category});
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final values = [
      _TestValue(
        value: 12,
        date: DateTime.now().add(const Duration(days: 1)),
        category: _ETestCategory.two,
      ),
      _TestValue(
        value: 5,
        date: DateTime.now().add(const Duration(days: 1)),
        category: _ETestCategory.one,
      ),
      _TestValue(
        value: 5,
        date: DateTime.now().add(const Duration(days: 2)),
        category: _ETestCategory.one,
      ),
      _TestValue(
        value: 12,
        date: DateTime.now().add(const Duration(days: 2)),
        category: _ETestCategory.three,
      ),
      _TestValue(
        value: 8,
        date: DateTime.now().add(const Duration(days: 2)),
        category: _ETestCategory.two,
      ),
      _TestValue(value: 3, date: DateTime.now(), category: _ETestCategory.one),
      _TestValue(value: 10, date: DateTime.now(), category: _ETestCategory.one),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          // -> app bar
          const AppBarComponent(
            title: Text("Статистика"),
            automaticallyImplyLeading: false,
          ),

          // -> graph
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            sliver: SliverToBoxAdapter(
              child: AspectRatio(
                aspectRatio: 1.3,
                child: ColoredBox(
                  color: theme.colorScheme.surfaceDim,
                  child: ChartComponent(
                    config: ChartConfig(
                      gridColor: theme.colorScheme.onSurfaceVariant,
                    ),
                    data: values.map((e) {
                      return ChartMarkComponent.bar(
                        x: ChartPlottableValue.temporal(
                          "Date",
                          value: e.date,
                          component: EChartTemporalComponent.weekday,
                        ),
                        y: ChartPlottableValue.quantitative(
                          "Expense",
                          value: e.value,
                        ),
                        groupBy: e.category,
                      );
                    }).toList(growable: false),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
