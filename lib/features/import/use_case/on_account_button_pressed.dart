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

    final Map<EAccountType, List<String>> titles = {};
    if (accountModel.isFromData) {
      for (final element in accountModel.accounts.value) {
        if (element.account == null ||
            element.originalTitle == value.originalTitle) continue;
        if (!titles.containsKey(element.account!.type)) {
          titles[element.account!.type] = [element.account!.title];
        } else {
          titles[element.account!.type]!.add(element.account!.title);
        }
      }
    }

    final account = value.account ??
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
          account: account,
          additionalUsedTitles: titles,
        );
      },
    );

    if (!context.mounted || result == null) return;

    viewModel.setProtectedState(() {
      if (value.originalTitle == null) {
        accountModel.accounts.value = [
          ImportModelAccountVO(account: result, originalTitle: null),
        ];
      } else {
        final index = accountModel.accounts.value
            .indexWhere((e) => e.originalTitle == value.originalTitle);
        if (index == -1) {
          throw RangeError.index(index, accountModel.accounts.value);
        }
        accountModel.accounts.value = List.from(accountModel.accounts.value)
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
