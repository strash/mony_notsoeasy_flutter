import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/import/page/view_model.dart";

typedef TPressedCategoryValue = ({
  ETransactionType transactionType,
  TMappedCategory category,
});

final class OnCategoryButtonPressed
    extends UseCase<void, TPressedCategoryValue> {
  @override
  void call(BuildContext context, [TPressedCategoryValue? value]) {
    if (value == null) throw ArgumentError.notNull();
    print(value);
  }
}
