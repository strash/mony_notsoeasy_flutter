import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/charts/component.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/stats/page/view_model.dart";

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<StatsViewModel>();
    final transactions = viewModel.transactions.where((e) {
      return e.category.transactionType == viewModel.activeTransactionType;
    });

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
                child: transactions.isNotEmpty
                    // -> chart
                    ? ChartComponent(
                        config: ChartConfig(
                          padding: 2.0,
                          radius: 4.0,
                          gridColor: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: .5),
                          legendStyle: GoogleFonts.golosText(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          groupColor: (group) {
                            final category = group as CategoryModel?;
                            if (category == null || ex == null) {
                              return theme.colorScheme.tertiaryContainer;
                            }
                            return ex.from(category.colorName).color;
                          },
                          compareTo: (groupA, groupB) {
                            final a = groupA as CategoryModel?;
                            final b = groupB as CategoryModel?;
                            return a?.title.compareTo(b?.title ?? "") ?? 0;
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
                            groupBy: e.category,
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
