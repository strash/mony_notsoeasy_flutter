import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";
import "package:provider/provider.dart";

final class OnDeleteTransactionPressed
    extends UseCase<Future<void>, TransactionModel> {
  @override
  Future<void> call(
    BuildContext context, [
    TransactionModel? transaction,
  ]) async {
    if (transaction == null) throw ArgumentError.notNull();

    final result = await AlertComponet.show(
      context,
      title: const Text("Удаление транзакции"),
      description: const Text(
        "Точно удалить?\nВосстановить потом не получится.",
      ),
    );

    if (!context.mounted) return;

    switch (result) {
      case null || EAlertResult.cancel:
        return;
      case EAlertResult.ok:
        final transactionService = context.read<DomainTransactionService>();
        final appService = context.viewModel<AppEventService>();

        await transactionService.delete(id: transaction.id);

        appService.notify(
          EventTransactionDeleted(
            sender: TransactionViewModel,
            transaction: transaction,
          ),
        );
    }
  }
}
