import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/feed/components/components.dart";
import "package:mony_app/features/feed/page/view_model.dart";

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<FeedViewModel>();

    return Scaffold(
      body: ListView.builder(
        itemCount: viewModel.transactions.length,
        itemBuilder: (context, index) {
          final transaction = viewModel.transactions.elementAt(index);
          return FeedItemComponent(transaction: transaction);
        },
      ),
    );
  }
}
