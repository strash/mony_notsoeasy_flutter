import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/start_account_create/page/view_model.dart";
import "package:provider/provider.dart";

final class OnCreateAccountPressedUseCase
    extends BaseValueUseCase<AccountValueObject?, Future<void>> {
  AccountValueObject? _value;

  @override
  AccountValueObject? get value => _value;

  @override
  set value(AccountValueObject? newValue) {
    _value = newValue;
  }

  @override
  Future<void> action(BuildContext context) async {
    final value = this.value;
    if (value == null) throw ArgumentError.notNull();
    final accountService = context.read<AccountService>();
    final eventService = ViewModel.of<AppEventService>(context);
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
