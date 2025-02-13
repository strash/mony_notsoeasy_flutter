import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";

final class OnAccountButtonPressed
    extends UseCase<Future<void>, ImportModelAccountVO> {
  @override
  Future<void> call(BuildContext context, [ImportModelAccountVO? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<ImportViewModel>();
    final accountModel = viewModel.currentStep;

    if (accountModel is! ImportModelAccount) {
      throw ArgumentError.value(accountModel);
    }

    final account =
        value.account ??
        AccountVO(
          title: value.originalTitle ?? "",
          type: EAccountType.defaultValue,
          currencyCode: kDefaultCurrencyCode,
          colorName: EColorName.random().name,
          balance: 0.0,
        );

    final result = await BottomSheetComponent.show<AccountVO?>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return AccountFormPage(
          keyboardHeight: bottom,
          account: AccountVariantVO(vo: account),
          additionalUsedTitles: accountModel.getTitles(value),
        );
      },
    );

    if (!context.mounted || result == null) return;

    viewModel.setProtectedState(() {
      if (value.originalTitle == null) {
        accountModel.accounts = [
          ImportModelAccountVO(account: result, originalTitle: null),
        ];
      } else {
        final index = accountModel.accounts.indexWhere(
          (e) => e.originalTitle == value.originalTitle,
        );
        if (index == -1) {
          throw RangeError.index(index, accountModel.accounts);
        }
        accountModel.accounts =
            List.from(accountModel.accounts)
              ..removeAt(index)
              ..insert(
                index,
                ImportModelAccountVO(
                  account: result,
                  originalTitle: value.originalTitle,
                ),
              );
      }
    });
  }
}
