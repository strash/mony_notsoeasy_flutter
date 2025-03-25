import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/features/stats/components/components.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:mony_app/i18n/strings.g.dart";

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<StatsViewModel>();
    final transactions = viewModel.transactions;
    const keyPrefix = "stats_feed";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        controller: viewModel.scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> app bar
          AppBarComponent(
            title: Text(context.t.features.stats.title),
            automaticallyImplyLeading: false,
            // -> temporal type
            trailing: const StatsTemporalViewMenuComponent(),
          ),

          // -> account select
          SliverPadding(
            padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
            sliver: SliverToBoxAdapter(
              child: AccountSelectComponent(
                controller: viewModel.accountController,
                accounts: viewModel.accounts,
                isColorsVisible: viewModel.isColorsVisible,
              ),
            ),
          ),

          // -> total amount
          const SliverPadding(
            padding: EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
            sliver: SliverToBoxAdapter(child: StatsTotalAmountComponent()),
          ),

          // -> date range
          const SliverPadding(
            padding: EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
            sliver: SliverToBoxAdapter(child: StatsDateRangeComponent()),
          ),

          // -> transaction type selector
          SliverPadding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
            sliver: SliverToBoxAdapter(
              child: SeparatedComponent.builder(
                direction: Axis.horizontal,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10.0);
                },
                itemCount: ETransactionType.values.length,
                itemBuilder: (context, index) {
                  final item = ETransactionType.values.elementAt(index);

                  return StatsTransactionTypeButtonComponent(type: item);
                },
              ),
            ),
          ),

          // -> chart
          const SliverPadding(
            padding: EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
            sliver: SliverToBoxAdapter(child: StatsChartComponent()),
          ),

          // TODO: фильтровать по категориям
          // -> chart legend (categories)
          const SliverPadding(
            padding: EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
              child: StatsCategoriesComponent(padding: 15.0),
            ),
          ),

          // -> feed
          SliverPadding(
            padding: const EdgeInsets.only(top: 15.0),
            sliver: TransactionListComponent(
              transactions: transactions,
              keyPrefix: keyPrefix,
              isCentsVisible: viewModel.isCentsVisible,
              isColorsVisible: viewModel.isColorsVisible,
              isTagsVisible: viewModel.isTagsVisible,
              showFullDate: false,
              emptyStateColor: theme.colorScheme.onSurfaceVariant,
              onTransactionPressed:
                  viewModel<OnTransactionWithContextMenuPressed>(),
              onTransactionMenuSelected:
                  viewModel<OnTransactionWithContextMenuSelected>(),
            ),
          ),
        ],
      ),
    );
  }
}
