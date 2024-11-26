import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account_form/page/page.dart";
import "package:mony_app/features/category_form/page/page.dart";
import "package:mony_app/features/feed/page/page.dart";
import "package:provider/provider.dart";

final class OnMenuAddPressed extends UseCase<Future<void>, EFeedMenuItem> {
  @override
  Future<void> call(BuildContext context, [EFeedMenuItem? value]) async {
    if (value == null) throw ArgumentError.notNull();
    switch (value) {
      case EFeedMenuItem.addAccount:
        _addAccount(context);
      case EFeedMenuItem.addExpenseCategory:
        _addCategory(context, ETransactionType.expense);
      case EFeedMenuItem.addIncomeCategory:
        _addCategory(context, ETransactionType.income);
    }
  }

  Future<void> _addAccount(BuildContext context) async {
    final result = await BottomSheetComponent.show<AccountVO?>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return AccountFormPage(
          keyboardHeight: bottom,
          account: null,
          additionalUsedTitles: const {},
        );
      },
    );

    if (!context.mounted || result == null) return;

    final accountService = context.read<DomainAccountService>();
    final appService = context.viewModel<AppEventService>();

    final account = await accountService.create(vo: result);
    appService.notify(
      EventAccountCreated(sender: FeedViewModel, value: account),
    );
  }

  Future<void> _addCategory(BuildContext context, ETransactionType type) async {
    final result = await BottomSheetComponent.show<AccountVO?>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return CategoryFormPage(
          keyboardHeight: bottom,
          category: null,
          transactionType: type,
          additionalUsedTitles: const [],
        );
      },
    );

    if (!context.mounted || result == null) return;

    // TODO: доделать создание категории
  }
}
