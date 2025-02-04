import "package:flutter/material.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/stats/components/categories_chart.dart";
import "package:mony_app/features/stats/components/categories_legend.dart";
import "package:mony_app/features/stats/page/view_model.dart";

class StatsCategoriesComponent extends StatelessWidget {
  final double padding;

  const StatsCategoriesComponent({
    super.key,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();

    final viewModel = context.viewModel<StatsViewModel>();
    final categories = viewModel.categories;
    final totalCount = categories.fold(.0, (prev, curr) => prev + curr.$1);
    final chartData = categories.map((e) {
      return (
        e.$1,
        ex != null && viewModel.isColorsVisible
            ? ex.from(e.$2.colorName).color
            : theme.colorScheme.tertiary,
      );
    });

    return SeparatedComponent.list(
      mainAxisSize: MainAxisSize.min,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10.0);
      },
      children: [
        // -> chart
        AnimatedSwitcher(
          duration: Durations.short3,
          child: StatsCategoriesChartComponent(
            key: Key("stats_categories_${totalCount}_$categories"),
            padding: padding,
            totalCount: totalCount,
            data: chartData,
          ),
        ),

        // -> legend
        Row(
          children: [
            Expanded(
              child: StatsCategoriesLegendComponent(
                controller: viewModel.categoryScrollController,
                padding: padding,
                data: chartData,
                categories: categories,
                totalCount: totalCount,
                account: viewModel.accountController.value,
                isCentsVisible: viewModel.isCentsVisible,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
