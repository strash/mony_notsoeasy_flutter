import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/transaction_form/page/page.dart";
import "package:provider/provider.dart";

final class OnAddTransactionPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final transactionService = context.read<DomainTransactionService>();
    final appService = context.viewModel<AppEventService>();

    final result = await BottomSheetComponent.show<TransactionFormVO?>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return const TransactionFormPage();
      },
    );
    if (result == null) return;

    final transactionModel = await transactionService.create(
      vo: result.transactionVO,
      tags: result.tags,
    );

    if (transactionModel != null) {
      appService.notify(
        EventTransactionCreated(
          sender: TransactionFormViewModel,
          transaction: transactionModel,
        ),
      );
    }
  }
}
