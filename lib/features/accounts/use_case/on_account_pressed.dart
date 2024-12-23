import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/features/account/account.dart";

final class OnAccountPressed extends UseCase<Future<void>, AccountModel> {
  @override
  Future<void> call(BuildContext context, [AccountModel? value]) async {
    if (value == null) throw ArgumentError.notNull();

    context.go<void>(AccountPage(account: value));
  }
}
