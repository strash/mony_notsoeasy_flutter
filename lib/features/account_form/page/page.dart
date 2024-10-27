import "package:flutter/material.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/services/vo/vo.dart";
import "package:mony_app/features/account_form/page/view_model.dart";

export "./view_model.dart";

class AccountFormPage extends StatelessWidget {
  final double keyboardHeight;
  final AccountVO? account;
  final Map<EAccountType, List<String>> titles;

  const AccountFormPage({
    super.key,
    required this.keyboardHeight,
    required this.account,
    required this.titles,
  });

  @override
  Widget build(BuildContext context) {
    return AccountFormViewModelBuilder(
      keyboardHeight: keyboardHeight,
      account: account,
      titles: titles,
    );
  }
}
