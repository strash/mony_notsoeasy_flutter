import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/alert/component.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/services/database/account.dart";
import "package:mony_app/features/account/page/view_model.dart";
import "package:provider/provider.dart";

final class OnDeleteAccountPressed extends UseCase<Future<void>, AccountModel> {
  @override
  Future<void> call(BuildContext context, [AccountModel? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final result = await AlertComponet.show(
      context,
      title: const Text("Удаление счета"),
      description: const Text(
        "Вместе со счетом будут удалены все транзакции, связанные с этим "
        "счетом. Точно удалить? Восстановить потом не получится.",
      ),
    );

    if (!context.mounted) return;

    switch (result) {
      case null || EAlertResult.cancel:
        return;
      case EAlertResult.ok:
        final accountService = context.read<DomainAccountService>();
        final appService = context.viewModel<AppEventService>();

        await accountService.delete(id: value.id);

        appService.notify(
          EventAccountDeleted(
            sender: AccountViewModel,
            value: value,
          ),
        );
    }
  }
}
