import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/new_expense/page/page.dart";

final class OnAddExpensePressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [dynamic _]) {
    BottomSheetComponent.show(context, child: const NewExpensePage());
  }
}
