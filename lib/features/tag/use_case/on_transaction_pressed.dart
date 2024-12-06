import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/transaction/transaction.dart";

final class OnTransactionPressed extends UseCase<void, TransactionModel> {
  @override
  void call(BuildContext context, [TransactionModel? transaction]) {
    if (transaction == null) throw ArgumentError.notNull();

    context.go(TransactionPage(transaction: transaction));
  }
}
