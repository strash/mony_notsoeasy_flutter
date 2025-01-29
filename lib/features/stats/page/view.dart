import "package:flutter/material.dart";
import "package:mony_app/components/components.dart";
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
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            sliver: SliverToBoxAdapter(
              child: StatsAccountSelectComponent(),
            ),
          ),

          // -> chart
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            sliver: SliverToBoxAdapter(
              child: StatsChartComponent(),
            ),
          ),

          // -> bottom offset
          SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
