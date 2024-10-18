import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/start_account_create/page/view_model.dart";
import "package:provider/provider.dart";

final class OnCreateAccountPressedUseCase
    extends BaseValueUseCase<AccountValueObject, Future<void>> {
  @override
  Future<void> action(BuildContext context, AccountValueObject value) async {
    final accountService = context.read<AccountService>();
    final eventService = context.viewModel<AppEventService>();
    final account = await accountService.create(value);
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      eventService.notify(
        EventAccountCreated(
          sender: StartAccountCreateViewModel,
          account: account,
        ),
      );
    }
  }
}
