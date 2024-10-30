import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/features/navbar/page/view.dart";

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<FeedViewModel>();

    return Scaffold(
      body: ListView.builder(
        controller: viewModel.scrollController,
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom +
              NavBarView.kBottomMargin * 2.0 +
              NavBarView.kTabHeight +
              50.h,
        ),
        itemCount: viewModel.transactions.length,
        itemBuilder: (context, index) {
          final transaction = viewModel.transactions.elementAt(index);
          return FeedItemComponent(transaction: transaction);
        },
      ),
    );
  }
}
