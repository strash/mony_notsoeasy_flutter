import "package:flutter/material.dart";
import "package:mony_app/features/account_create/page/view_model.dart";

export "./view_model.dart";

class AccountCreatePage extends StatelessWidget {
  const AccountCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccountCreateViewModelBuilder();
  }
}
