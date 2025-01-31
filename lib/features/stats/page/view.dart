import "package:flutter/material.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/stats/components/components.dart";

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomOffset = NavBarView.bottomOffset(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> app bar
          const AppBarComponent(
            title: Text("Статистика"),
            automaticallyImplyLeading: false,
            // -> temporal type
            trailing: StatsTemporalViewMenuComponent(),
          ),

          // -> account select
          const SliverPadding(
            padding: EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
            sliver: SliverToBoxAdapter(
              child: StatsAccountSelectComponent(),
            ),
          ),

          // -> total amount
          const SliverPadding(
            padding: EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
            sliver: SliverToBoxAdapter(
              child: StatsTotalAmountComponent(),
            ),
          ),

          // -> transaction type selector
          SliverPadding(
            padding: const EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
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

          // TODO: paging
          // -> chart
          const SliverPadding(
            padding: EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
            sliver: SliverToBoxAdapter(
              child: StatsChartComponent(),
            ),
          ),

          // -> chart legend (categories)
          const SliverPadding(
            padding: EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
              child: StatsCategoriesComponent(padding: 15.0),
            ),
          ),

          // -> transactions
          const SliverPadding(
            padding: EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
            sliver: SliverToBoxAdapter(
              child: Text("[Транзакции]"),
            ),
          ),

          // -> bottom offset
          SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
