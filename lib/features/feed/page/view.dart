import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/features/feed/page/page.dart";

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<FeedViewModel>(context);

    return Scaffold(
      body: Center(
        child: FutureBuilder<List<AccountModel>>(
          future: viewModel.getAccounts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: snapshot.data!.map((e) {
                return Text(e.title);
              }).toList(growable: false),
            );
          },
        ),
      ),
    );
  }
}
