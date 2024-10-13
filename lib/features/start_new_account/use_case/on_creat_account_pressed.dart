import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start_new_account_create/page/page.dart";

final class OnCreatAccountPressedUseCase extends BaseUseCase<void> {
  @override
  void action(BuildContext context) {
    context.go(const StartNewAccountCreatePage());
  }
}
