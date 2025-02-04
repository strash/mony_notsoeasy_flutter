import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/charts/component.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/features/stats/page/view_model.dart";

class StatsChartComponent extends StatelessWidget {
  const StatsChartComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();

    final viewModel = context.viewModel<StatsViewModel>();
    final transactions = viewModel.transactions;
    final account = viewModel.accountController.value;
    final formatter = account != null
        ? NumberFormat.compactCurrency(
            name: account.currency.name,
            symbol: account.currency.symbol,
            decimalDigits: 0,
          )
        : NumberFormat.compact();

    return AspectRatio(
      aspectRatio: 1.5,
      child: transactions.isNotEmpty
          // -> chart
          ? ChartComponent(
              config: ChartConfig(
                gridColor:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: .4),
                gridSecondaryColor:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: .2),
                showMedian: true,
                medianLineColor: theme.colorScheme.primary,
                medianPadding: const EdgeInsets.symmetric(
                  horizontal: 4.5,
                  vertical: 1.5,
                ),
                medianRadius: 6.0,
                medianStyle: GoogleFonts.golosText(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
                padding: switch (viewModel.activeTemporalView) {
                  EChartTemporalView.year => 3.0,
                  EChartTemporalView.month => 1.5,
                  EChartTemporalView.week => 5.0,
                },
                radius: switch (viewModel.activeTemporalView) {
                  EChartTemporalView.year => 6.0,
                  EChartTemporalView.month => 3.0,
                  EChartTemporalView.week => 10.0,
                },
                legendStyle: GoogleFonts.golosText(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                groupColor: (group) {
                  final category = group as CategoryModel?;
                  if (!viewModel.isColorsVisible ||
                      category == null ||
                      ex == null) {
                    return theme.colorScheme.tertiary;
                  }
                  return ex.from(category.colorName).color;
                },
                compareTo: (groupA, groupB) {
                  final a = groupA as CategoryModel?;
                  final b = groupB as CategoryModel?;
                  return a?.title.compareTo(b?.title ?? "") ?? 0;
                },
                yFormatter: (value) {
                  return formatter.format(value);
                },
              ),
              data: transactions.map((e) {
                return ChartMarkComponent.bar(
                  x: ChartPlottableValue.temporal(
                    "Date",
                    value: e.date.startOfDay,
                    component: viewModel.activeTemporalView,
                  ),
                  y: ChartPlottableValue.quantitative(
                    "Expense",
                    value: e.amount.abs(),
                  ),
                  groupBy: viewModel.isColorsVisible ? e.category : null,
                );
              }).toList(growable: false),
            )

          // -> empty state
          : Center(
              child: Text(
                "Нет данных",
                style: GoogleFonts.golosText(
                  fontSize: 16.0,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
    );
  }
}
