import "package:flutter/material.dart";
import "package:mony_app/domain/services/vo/vo.dart";
import "package:mony_app/features/account_form/page/view_model.dart";

export "./view_model.dart";

class AccountFormPage extends StatelessWidget {
  final double keyboardHeight;
  final AccountVO? account;

  const AccountFormPage({
    super.key,
    this.account,
    required this.keyboardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AccountFormViewModelBuilder(
      account: account,
      keyboardHeight: keyboardHeight,
    );
  }
}
