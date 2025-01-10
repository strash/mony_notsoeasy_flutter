import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/features.dart";

final class OnTransactionPressed extends UseCase<void, TransactionModel> {
  @override
  void call(BuildContext context, [TransactionModel? value]) {
    if (value == null) throw ArgumentError.notNull();

    context.go<void>(TransactionPage(transaction: value));
  }
}
