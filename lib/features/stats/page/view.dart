import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/charts/component.dart";
import "package:mony_app/features/navbar/page/view.dart";

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
    final bottomOffset = NavBarView.bottomOffset(context);

    final values = [
      _TestValue(value: 1, date: DateTime.now(), category: _ETestCategory.one),
      _TestValue(
        value: 8,
        date: DateTime.now().add(const Duration(days: 1)),
        category: _ETestCategory.two,
      ),
      _TestValue(
        value: 10,
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
        value: 15,
        date: DateTime.now().add(const Duration(days: 2)),
        category: _ETestCategory.two,
      ),
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
                aspectRatio: 1.25,
                child: ChartComponent(
                  config: ChartConfig(
                    gridColor: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: .5),
                    groupColor: (group) {
                      return switch (group as _ETestCategory?) {
                        null => theme.colorScheme.error,
                        _ETestCategory.one => Colors.indigoAccent,
                        _ETestCategory.two => theme.colorScheme.secondary,
                        _ETestCategory.three => Colors.deepOrangeAccent,
                      };
                    },
                    padding: 5.0,
                    radius: 5.0,
                    legendStyle: GoogleFonts.golosText(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
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

          // -> bottom offset
          SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
