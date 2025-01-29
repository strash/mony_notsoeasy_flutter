import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/stats/components/components.dart";
import "package:mony_app/features/stats/page/view_model.dart";

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
          const SliverPadding(padding: EdgeInsets.only(top: 10.0)),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverToBoxAdapter(
              child: StatsAccountSelectComponent(),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(top: 15.0)),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -> total amount
                  StatsTotalAmountComponent(),

                  // -> date range
                  StatsDateRangeComponent(),
                ],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(top: 15.0)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverToBoxAdapter(
              child: Text("Сумма расходов"),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverToBoxAdapter(
              child: Text("Сумма доходов"),
            ),
          ),

          // -> chart
          const SliverPadding(padding: EdgeInsets.only(top: 15.0)),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverToBoxAdapter(
              child: StatsChartComponent(),
            ),
          ),

          // -> chart legend (categories)
          const SliverPadding(padding: EdgeInsets.only(top: 15.0)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverToBoxAdapter(
              child: Text("Легенда категорий"),
            ),
          ),

          // -> transactions
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverToBoxAdapter(
              child: Text("Транзакции"),
            ),
          ),

          // -> bottom offset
          SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
