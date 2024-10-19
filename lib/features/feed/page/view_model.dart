import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/feed/page/view.dart";

class FeedViewModelBuilder extends StatefulWidget {
  const FeedViewModelBuilder({super.key});

  @override
  State<FeedViewModelBuilder> createState() => FeedViewModel();
}

final class FeedViewModel extends ViewModelState<FeedViewModelBuilder> {
  // late final _accountService = context.read<AccountService>();

  // Future<List<AccountModel>> getAccounts() async {
  //   final accounts = await _accountService.getAll();
  //   return accounts;
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModel<FeedViewModel>(
      viewModel: this,
      child: const FeedView(),
    );
  }
}
