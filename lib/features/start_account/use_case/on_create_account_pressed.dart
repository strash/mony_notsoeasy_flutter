import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/start_account_create/page/page.dart";

final class OnCreateAccountPressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [dynamic _]) {
    context.go(const StartAccountCreatePage());
  }
}
