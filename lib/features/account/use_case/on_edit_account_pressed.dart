import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account_form/page/page.dart";
import "package:provider/provider.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class OnEditAccountPressed extends UseCase<Future<void>, AccountModel> {
  @override
  Future<void> call(BuildContext context, [AccountModel? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final accountService = context.read<DomainAccountService>();
    final appService = context.viewModel<AppEventService>();

    final result = await BottomSheetComponent.show<AccountVO?>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return AccountFormPage(
          keyboardHeight: bottom,
          account: AccountVariantModel(model: value),
          additionalUsedTitles: const {},
        );
      },
    );

    if (!context.mounted || result == null) return;

    final account = await accountService.update(
      model: value.copyWith(
        title: result.title,
        colorName: EColorName.from(result.colorName),
        type: result.type,
        currency: FiatCurrency.fromCode(result.currencyCode),
        balance: result.balance,
      ),
    );

    appService.notify(EventAccountUpdated(account));
  }
}
