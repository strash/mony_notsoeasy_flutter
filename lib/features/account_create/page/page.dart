import "package:flutter/material.dart";
import "package:mony_app/features/account_create/page/view_model.dart";

export "./view_model.dart";

class AccountCreatePage extends StatelessWidget {
  final ScrollController scrollController;

  const AccountCreatePage({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return AccountCreateViewModelBuilder(scrollController: scrollController);
  }
}
