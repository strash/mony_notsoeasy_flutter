import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/new_expense/page/page.dart";

final class OnAddExpensePressedUseCase extends BaseUseCase<void> {
  @override
  void action(BuildContext context) {
    BottomSheetComponent.show(context, child: const NewExpensePage());
  }
}
