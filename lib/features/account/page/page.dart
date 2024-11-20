import "package:flutter/material.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/features/account/page/view_model.dart";

export "./view_model.dart";

class AccountPage extends StatelessWidget {
  final AccountModel account;

  const AccountPage({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return AccountViewModelBuilder(account: account);
  }
}
