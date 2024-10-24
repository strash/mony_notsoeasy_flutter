import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/new_transaction/page/page.dart";

final class OnAddTransactionPressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [dynamic _]) {
    BottomSheetComponent.show(
      context,
      builder: (context) {
        return const NewTransactionPage();
      },
    );
  }
}
