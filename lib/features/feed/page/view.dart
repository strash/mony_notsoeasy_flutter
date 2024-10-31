import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/features/navbar/page/view.dart";

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomOffset = MediaQuery.paddingOf(context).bottom +
        NavBarView.kBottomMargin * 2.0 +
        NavBarView.kTabHeight +
        50.h;

    final viewModel = context.viewModel<FeedViewModel>();
    final sectionCurrency = viewModel.sectionCurrency;

    return Scaffold(
      body: ListView.builder(
        controller: viewModel.scrollController,
        padding: EdgeInsets.only(bottom: bottomOffset),
        itemCount: viewModel.feed.length,
        findChildIndexCallback: (key) {
          final id = (key as ValueKey<String>).value;
          return viewModel.feed.indexWhere((e) {
            if (e.type == EFeedItem.section) {
              return id == (e.value as (DateTime, double)).$1.toString();
            }
            return id == (e.value as TransactionModel).id;
          });
        },
        itemBuilder: (context, index) {
          final item = viewModel.feed.elementAt(index);

          // -> section
          if (item.type == EFeedItem.section) {
            final value = item.value as (DateTime, double);
            return FeedSectionComponent(
              key: ValueKey<String>(value.$1.toString()),
              value: value,
              currency: sectionCurrency!,
            );
          }

          // -> transaction
          final value = item.value as TransactionModel;
          return FeedItemComponent(
            key: ValueKey<String>(value.id),
            transaction: value,
          );
        },
      ),
    );
  }
}
