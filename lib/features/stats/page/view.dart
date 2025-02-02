import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/stats/components/components.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:mony_app/features/stats/use_case/use_case.dart";

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<StatsViewModel>();
    final transactions = viewModel.transactions;
    final feed = transactions.toFeed();
    const keyPrefix = "stats";

    final onTransactionPressed = viewModel<OnTransactionPressed>();

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
          // TODO: открывать календарь чтобы переключить на другой период
          // TODO: слушать навбар и скролить до верха при тапе на иконку
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
          SliverPadding(
            padding: const EdgeInsets.only(top: 15.0),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 25.0);
              },
              itemCount: feed.length,
              findChildIndexCallback: (key) {
                final id = (key as ValueKey<String>).value;
                final index = feed.indexWhere((e) {
                  return id == feed.key(e, keyPrefix).value;
                });
                return index != -1 ? index : null;
              },
              itemBuilder: (context, index) {
                final item = feed.elementAt(index);
                final key = feed.key(item, keyPrefix);

                return switch (item) {
                  FeedItemSection() => Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, .0),
                      child: FeedSectionComponent(
                        key: key,
                        section: item,
                        showDecimal: viewModel.isCentsVisible,
                      ),
                    ),
                  FeedItemTransaction() => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTransactionPressed(
                        context,
                        item.transaction,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: FeedItemComponent(
                          key: key,
                          transaction: item.transaction,
                          showDecimal: viewModel.isCentsVisible,
                          showColors: viewModel.isColorsVisible,
                          showTags: viewModel.isTagsVisible,
                        ),
                      ),
                    )
                };
              },
            ),
          ),

          // -> bottom offset
          SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
