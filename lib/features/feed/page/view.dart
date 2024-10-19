import "package:flutter/material.dart";

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    // final viewModel = context.viewModel<FeedViewModel>();

    return const Scaffold(
      body: Center(
          // child: FutureBuilder<List<AccountModel>>(
          //   future: viewModel.getAccounts(),
          //   builder: (context, snapshot) {
          //     if (!snapshot.hasData) return const SizedBox();
          //     return Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: snapshot.data!.map((e) {
          //         return Text(e.title);
          //       }).toList(growable: false),
          //     );
          //   },
          // ),
          ),
    );
  }
}
