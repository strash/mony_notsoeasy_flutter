import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/models/transaction.dart";

final class OnDeleteTransactionPressed
    extends UseCase<Future<void>, TransactionModel> {
  @override
  Future<void> call(BuildContext context, [TransactionModel? value]) async {
    if (value == null) throw ArgumentError.notNull();
  }
}
