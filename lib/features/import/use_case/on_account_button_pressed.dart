import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";

/// Use `OnAccountFromImportButtonPressedDecorator` or
/// `OnAccountLocalButtonPressedDecorator` instead
final class OnAccountButtonPressed
    extends UseCase<Future<AccountVO?>, AccountVO?> {
  @override
  Future<AccountVO?> call(BuildContext context, [AccountVO? value]) async {
    final result = await BottomSheetComponent.show<AccountVO?>(
      context,
      showDragHandle: false,
      builder: (context) {
        return AccountFormPage(account: value);
      },
    );
    return result;
  }
}
