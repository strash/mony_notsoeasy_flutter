import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/components/bottom_sheet/component.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/services/database/account.dart";
import "package:mony_app/features/balance_exchange_form/balance_exchange_form.dart";
import "package:provider/provider.dart";

typedef _TValue = ({EBalanceExchangeMenuItem item, AccountModel account});

final class OnBalanceExchangeMenuSelected
    extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:item, :account) = value;
    final accountService = context.read<DomainAccountService>();
    final appService = context.viewModel<AppEventService>();

    final result =
        await BottomSheetComponent.show<(AccountModel, AccountModel)>(
          context,
          showDragHandle: false,
          builder: (context, bottom) {
            return BalanceExchangeFormPage(
              keyboardHeight: bottom,
              account: account,
              action: item,
            );
          },
        );

    // NOTE: don't check if context mounted because the context is from the menu
    if (result == null) return;

    final left = await accountService.update(model: result.$1);
    final right = await accountService.update(model: result.$2);

    appService.notify(EventAccountUpdated(left));
    appService.notify(EventAccountUpdated(right));
  }
}
