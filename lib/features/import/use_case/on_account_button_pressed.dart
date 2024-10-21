import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";

final class OnAccountButtonPressed
    extends UseCase<Future<void>, MapEntry<String, AccountVO?>> {
  @override
  Future<void> call(
    BuildContext context, [
    MapEntry<String, AccountVO?>? value,
  ]) async {
    if (value == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<ImportViewModel>();
    final account = value.value ??
        AccountVO(
          title: value.key,
          type: EAccountType.defaultValue,
          currencyCode: kDefaultCurrencyCode,
          color: Palette().randomColor,
          balance: 0.0,
        );
    final result = await BottomSheetComponent.show<AccountVO?>(
      context,
      initialChildSize: 1.0,
      expand: false,
      showDragHandle: false,
      builder: (context, scrollController) {
        return AccountFormPage(
          account: account,
          scrollController: scrollController,
        );
      },
    );
    if (result != null) {
      viewModel.setProtectedState(() {
        viewModel.accounts[value.key] = result;
      });
    }
  }
}
