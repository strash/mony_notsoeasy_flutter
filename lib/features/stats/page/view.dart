import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:mony_app/features/stats/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<StatsViewModel>();
    final account = viewModel.activeAccount;
    final transactions = viewModel.transactions;
    final formatter = account != null
        ? NumberFormat.compactCurrency(
            name: account.currency.name,
            symbol: account.currency.symbol,
            decimalDigits: 0,
          )
        : NumberFormat.compact();

    final currContext = context;
    final onTemporalButtonPressed = viewModel<OnTemporalButtonPressed>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> app bar
          AppBarComponent(
            title: const Text("Статистика"),
            automaticallyImplyLeading: false,
            // -> temporal type
            trailing: ContextMenuComponent(
              showBackground: false,
              blurBackground: false,
              buttonBuilder: (context) {
                return SizedBox.square(
                  dimension: AppBarComponent.height,
                  child: Center(
                    child: SvgPicture.asset(
                      viewModel.activeTemporalView.icon,
                      width: 28.0,
                      height: 28.0,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                );
              },
              itemsBuilder: (context, dismiss) {
                return SeparatedComponent.builder(
                  mainAxisSize: MainAxisSize.min,
                  separatorBuilder: (context, index) {
                    return const ContextMenuSeparatorComponent(isBig: false);
                  },
                  itemCount: EChartTemporalView.values.length,
                  itemBuilder: (context, index) {
                    final item = EChartTemporalView.values.elementAt(index);

                    return ContextMenuItemComponent(
                      label: Text(item.description),
                      icon: SvgPicture.asset(
                        item.icon,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.onSurface,
                          BlendMode.srcIn,
                        ),
                      ),
                      isActive: viewModel.activeTemporalView == item,
                      onTap: () {
                        onTemporalButtonPressed(currContext, item);
                        dismiss();
                      },
                    );
                  },
                );
              },
            ),
          ),

          // -> graph
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            sliver: SliverToBoxAdapter(
              child: AspectRatio(
                aspectRatio: 1.15,
                child: transactions.isNotEmpty
                    // -> chart
                    ? ChartComponent(
                        config: ChartConfig(
                          gridColor: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: .4),
                          gridSecondaryColor: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: .2),
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

extension on EChartTemporalView {
  String get description {
    return switch (this) {
      EChartTemporalView.year => "За год",
      EChartTemporalView.month => "За месяц",
      EChartTemporalView.week => "За неделю",
    };
  }

  String get icon {
    return switch (this) {
      EChartTemporalView.year => Assets.icons.ySquare,
      EChartTemporalView.month => Assets.icons.mSquare,
      EChartTemporalView.week => Assets.icons.wSquare,
    };
  }
}
