import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";

/// Use `OnAccountFromImportButtonPressedDecorator` or
/// `OnAccountLocalButtonPressedDecorator` instead
final class OnAccountButtonPressed
    extends UseCase<Future<AccountVO?>, AccountVO?> {
  @override
  Future<AccountVO?> call(BuildContext context, [AccountVO? value]) async {
    final viewModel = context.viewModel<ImportViewModel>();
    final Map<EAccountType, List<String>> accounts = {};
    for (final element in viewModel.accounts.entries) {
      if (element.value == value && value != null || element.value == null) {
        continue;
      }
      final list = accounts[element.value!.type];
      accounts[element.value!.type] = List<String>.from(list ?? [])
        ..add(element.value!.title);
    }
    final result = await BottomSheetComponent.show<AccountVO?>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return AccountFormPage(
          keyboardHeight: bottom,
          account: value,
          titles: accounts,
        );
      },
    );
    return result;
  }
}
