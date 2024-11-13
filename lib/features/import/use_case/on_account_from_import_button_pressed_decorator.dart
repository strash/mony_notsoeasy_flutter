import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";

final class OnAccountFromImportButtonPressedDecorator
    extends UseCase<Future<void>, MapEntry<String, AccountVO?>> {
  @override
  Future<void> call(
    BuildContext context, [
    MapEntry<String, AccountVO?>? value,
  ]) async {
    if (value == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<ImportViewModel>();
    final onAccountPressed = viewModel<OnAccountButtonPressed>();
    final account = value.value ??
        AccountVO(
          title: value.key,
          type: EAccountType.defaultValue,
          currencyCode: kDefaultCurrencyCode,
          colorName: EColorName.random().name,
          balance: 0.0,
        );
    final result = await onAccountPressed(context, account);
    if (result != null) {
      viewModel.setProtectedState(() {
        viewModel.accounts[value.key] = result;
      });
    }
  }
}
