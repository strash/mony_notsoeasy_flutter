import "package:flutter/widgets.dart" show BuildContext, Text;
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account_with_context_menu/component.dart"
    show EAccountContextMenuItem;
import "package:mony_app/components/alert/component.dart";
import "package:mony_app/components/bottom_sheet/sheet.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/services/database/account.dart";
import "package:mony_app/domain/services/database/vo/account.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/account_form/page/view_model.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";
import "package:sealed_currencies/sealed_currencies.dart";

typedef TAccountContextMenuValue =
    ({EAccountContextMenuItem menu, AccountModel account});

final class OnAccountWithContextMenuSelected
    extends UseCase<Future<void>, TAccountContextMenuValue> {
  @override
  Future<void> call(
    BuildContext context, [
    TAccountContextMenuValue? value,
  ]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:menu, :account) = value;
    final accountService = context.service<DomainAccountService>();
    final appService = context.viewModel<AppEventService>();
    final sharedPrefService = context.service<DomainSharedPreferencesService>();

    switch (menu) {
      // -> exchange
      case EAccountContextMenuItem.receive || EAccountContextMenuItem.send:
        final action =
            menu == EAccountContextMenuItem.receive
                ? EBalanceExchangeMenuItem.receive
                : EBalanceExchangeMenuItem.send;
        final result =
            await BottomSheetComponent.show<(AccountModel, AccountModel)>(
              context,
              showDragHandle: false,
              builder: (context, bottom) {
                return BalanceExchangeFormPage(
                  keyboardHeight: bottom,
                  account: account,
                  action: action,
                );
              },
            );

        // NOTE: don't check if context mounted
        if (result == null) return;
        final left = await accountService.update(model: result.$1);
        final right = await accountService.update(model: result.$2);
        appService.notify(EventAccountBalanceExchanged((left, right)));

      // -> edit
      case EAccountContextMenuItem.edit:
        final result = await BottomSheetComponent.show<AccountVO?>(
          context,
          showDragHandle: false,
          builder: (context, bottom) {
            return AccountFormPage(
              keyboardHeight: bottom,
              account: AccountVariantModel(model: account),
              additionalUsedTitles: const {},
            );
          },
        );
        // NOTE: don't check if context mounted
        if (result == null) return;
        final model = await accountService.update(
          model: account.copyWith(
            title: result.title,
            colorName: EColorName.from(result.colorName),
            type: result.type,
            currency: FiatCurrency.fromCode(result.currencyCode),
            balance: result.balance,
          ),
        );
        appService.notify(EventAccountUpdated(model));

      // -> delete
      case EAccountContextMenuItem.delete:
        final shouldConfirm =
            await sharedPrefService.getSettingsConfirmAccount();
        final EAlertResult? result;
        if (shouldConfirm) {
          result = await AlertComponet.show(
            // ignore: use_build_context_synchronously
            context,
            title: const Text("Удаление счета"),
            description: const Text(
              "Вместе со счетом будут удалены все транзакции, связанные с "
              "этим счетом. Эту проверку можно отключить в настройках.",
            ),
          );
        } else {
          result = EAlertResult.ok;
        }
        if (result == null) return;
        switch (result) {
          case EAlertResult.cancel:
            return;
          case EAlertResult.ok:
            await accountService.delete(id: account.id);
            appService.notify(EventAccountDeleted(account));
        }
    }
  }
}
