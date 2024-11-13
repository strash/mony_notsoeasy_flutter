import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/transaction_form/page/page.dart";

final class OnAddTransactionPressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [dynamic _]) {
    BottomSheetComponent.show(
      context,
      builder: (context, bottom) {
        return const TransactionFormPage();
      },
    );
  }
}
