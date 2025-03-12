import "package:flutter/widgets.dart" show BuildContext, Text;
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/alert/component.dart";
import "package:mony_app/components/bottom_sheet/sheet.dart";
import "package:mony_app/components/transaction_with_context_menu/component.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/services/database/transaction.dart";
import "package:mony_app/domain/services/database/vo/transaction_tag.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";
import "package:provider/provider.dart";

final class OnTransactionContextMenuSelected
    extends UseCase<Future<void>, TTransactionContextMenuValue> {
  @override
  Future<void> call(
    BuildContext context, [
    TTransactionContextMenuValue? value,
  ]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:menu, :transaction) = value;
    final transactionService = context.read<DomainTransactionService>();
    final appService = context.viewModel<AppEventService>();
    final sharedPrefService = context.read<DomainSharedPreferencesService>();
    final shouldConfirm =
        await sharedPrefService.getSettingsConfirmTransaction();

    if (!context.mounted) return;

    switch (menu) {
      // -> edit
      case ETransactionContextMenuItem.edit:
        final result = await BottomSheetComponent.show<TransactionFormVO?>(
          context,
          showDragHandle: false,
          builder: (context, bottom) {
            return TransactionFormPage(transaction: transaction);
          },
        );
        if (result == null) return;
        final model = await transactionService.update(
          transaction: transaction,
          vo: result.transactionVO,
          tags: result.tags,
        );
        if (model == null) return;
        appService.notify(EventTransactionUpdated(model));
        void action(TransactionTagVariantVO value) {
          TagModel? tag;
          for (final element in model.tags) {
            if (element.title == value.vo.title) {
              tag = element;
              break;
            }
          }
          if (tag != null) appService.notify(EventTagCreated(tag));
        }
        result.tags.whereType<TransactionTagVariantVO>().forEach(action);

      // -> delete
      case ETransactionContextMenuItem.delete:
        final EAlertResult? result;
        if (shouldConfirm) {
          result = await AlertComponet.show(
            context,
            title: const Text("Удаление транзакции"),
            description: const Text(
              "Эту проверку можно отключить в настройках.",
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
            await transactionService.delete(id: transaction.id);
            appService.notify(EventTransactionDeleted(transaction));
        }
    }
  }
}
