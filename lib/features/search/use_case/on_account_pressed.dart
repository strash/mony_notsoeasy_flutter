import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/features/features.dart";

final class OnAccountPressed extends UseCase<void, AccountModel> {
  @override
  void call(BuildContext context, [AccountModel? value]) {
    if (value == null) throw ArgumentError.notNull();

    context.go(AccountPage(account: value));
  }
}
