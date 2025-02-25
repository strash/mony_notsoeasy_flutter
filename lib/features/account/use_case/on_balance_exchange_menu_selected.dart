import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/components/bottom_sheet/component.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/features/balance_exchange_form/balance_exchange_form.dart";

typedef _TValue = ({EBalanceExchangeMenuItem item, AccountModel account});

final class OnBalanceExchangeMenuSelected
    extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:item, :account) = value;

    // FIXME: ->
    final result = await BottomSheetComponent.show(
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
  }
}
