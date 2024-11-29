import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:provider/provider.dart";

final class OnDeleteTransactionPressed
    extends UseCase<Future<void>, TransactionModel> {
  @override
  Future<void> call(BuildContext context, [TransactionModel? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final result = await AlertComponet.show(
      context,
      title: const Text("Удаление транзакции"),
      description: const Text(
        // TODO: не забыть сделать эту фичу
        "Эту проверку можно отключить в настройках.",
      ),
    );

    if (!context.mounted || result == null) return;

    switch (result) {
      case EAlertResult.cancel:
        return;
      case EAlertResult.ok:
        final transactionService = context.read<DomainTransactionService>();
        final appService = context.viewModel<AppEventService>();

        await transactionService.delete(id: value.id);

        appService.notify(EventTransactionDeleted(value));
    }
  }
}
