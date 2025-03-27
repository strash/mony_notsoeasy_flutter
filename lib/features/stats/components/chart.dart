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
    final colorScheme = ColorScheme.of(context);
    final ex = Theme.of(context).extension<ColorExtension>();

    final viewModel = context.viewModel<StatsViewModel>();
    final transactions = viewModel.transactions;
    if (transactions.isEmpty) return const SizedBox();

    // NOTE: we don't want "1,23 тыс." instead "1.23K" so don't pass a locale
    final formatter = NumberFormat.compact();

    return AspectRatio(
      aspectRatio: 1.5,
      child: ChartComponent(
        config: ChartConfig(
          gridColor: colorScheme.onSurfaceVariant.withValues(alpha: .4),
          gridSecondaryColor: colorScheme.onSurfaceVariant.withValues(
            alpha: .2,
          ),
          showMedian: true,
          medianLineColor: colorScheme.primary,
          medianPadding: const EdgeInsets.symmetric(
            horizontal: 4.5,
            vertical: 1.5,
          ),
          medianRadius: 6.0,
          medianStyle: GoogleFonts.golosText(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: colorScheme.onPrimary,
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
            color: colorScheme.onSurfaceVariant,
          ),
          groupColor: (group) {
            final category = group as CategoryModel?;
            if (!viewModel.isColorsVisible || category == null || ex == null) {
              return colorScheme.tertiary;
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
        data: transactions
            .map((e) {
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
            })
            .toList(growable: false),
      ),
    );
  }
}
