import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/bottom_sheet/sheet.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/transaction/page/page.dart";
import "package:mony_app/features/transaction_form/page/page.dart";
import "package:provider/provider.dart";

final class OnEditTransactionPressed
    extends UseCase<Future<void>, TransactionModel> {
  @override
  Future<void> call(
    BuildContext context, [
    TransactionModel? transaction,
  ]) async {
    if (transaction == null) throw ArgumentError.notNull();

    final result = await BottomSheetComponent.show<TransactionFormVO?>(
      context,
      builder: (context, bottom) {
        return TransactionFormPage(transaction: transaction);
      },
    );
    if (result == null || !context.mounted) return;

    final transactionService = context.read<DomainTransactionService>();
    final appService = context.viewModel<AppEventService>();

    final updated = await transactionService.update(
      transaction: transaction,
      vo: result,
    );
    if (updated == null) return;

    appService.notify(
      EventTransactionUpdated(
        sender: TransactionViewModel,
        transaction: updated,
      ),
    );
  }
}
