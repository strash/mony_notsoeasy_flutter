import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/navbar/page/view_model.dart";

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomOffset = MediaQuery.paddingOf(context).bottom +
        NavbarView.kBottomMargin * 2.0 +
        NavbarView.kTabHeight +
        50.h;

    final navbar = context.viewModel<NavbarViewModel>();
    final onTopOfScreenPressed = navbar<OnTopOfScreenPressed>();
    final viewModel = context.viewModel<FeedViewModel>();
    final scrollController = viewModel.scrollController;
    final sectionCurrency = viewModel.sectionCurrency;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            restorationId: "feed_page",
            controller: viewModel.pageController,
            physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
            // TODO:? если счет всего один, то только его показывать. если
            // счетов больше одного, то добавлять страницу для всех счетов
            itemCount: viewModel.accounts.length,
            itemBuilder: (context, pageIndex) {
              // TODO: создавать разные скролл контроллеры под каждую страницу
              // TODO: при скролее отдельно для каждого запоминать позицию
              // TODO: при переключении страниц, если есть позиция скролла
              // страницы, то прыгать на нее
              // TODO: если потянуть за левый край то показывать поиск
              // TODO: если потянуть за правый край то показывать создание счета

              return GestureDetector(
                onTapUp: (details) {
                  final value = (
                    details: details,
                    scrollController: scrollController,
                  );
                  onTopOfScreenPressed(context, value);
                },
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    // -> feed
                    SliverPadding(
                      padding: EdgeInsets.only(
                        top: bottomOffset,
                        bottom: bottomOffset,
                      ),
                      sliver: SliverList.builder(
                        itemCount: viewModel.feed.length,
                        findChildIndexCallback: (key) {
                          final id = (key as ValueKey<String>).value;
                          return viewModel.feed.indexWhere((e) {
                            return switch (e.type) {
                              EFeedItem.section => id ==
                                  (e.value as (DateTime, double)).$1.toString(),
                              EFeedItem.transaction =>
                                id == (e.value as TransactionModel).id,
                            };
                          });
                        },
                        itemBuilder: (context, index) {
                          final item = viewModel.feed.elementAt(index);

                          switch (item.type) {
                            // -> section
                            case EFeedItem.section:
                              final value = item.value as (DateTime, double);
                              return FeedSectionComponent(
                                key: ValueKey<String>(value.$1.toString()),
                                value: value,
                                currency: sectionCurrency!,
                              );
                            // -> transaction
                            case EFeedItem.transaction:
                              final value = item.value as TransactionModel;
                              return FeedItemComponent(
                                key: ValueKey<String>(value.id),
                                transaction: value,
                              );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // -> pager
          // TODO: при переключении страниц показывать пэйджер и прятать поиск
          const FeedPagerComponent(),
        ],
      ),
    );
  }
}
