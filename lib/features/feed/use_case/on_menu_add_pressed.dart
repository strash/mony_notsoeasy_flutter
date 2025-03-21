import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account_form/account_form.dart";
import "package:mony_app/features/category_form/category_form.dart";
import "package:mony_app/features/feed/feed.dart";
import "package:mony_app/features/tag_form/tag_form.dart";

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
      case EFeedMenuItem.addTag:
        _addTag(context);
    }
  }

  Future<void> _addAccount(BuildContext context) async {
    final accountService = context.service<DomainAccountService>();
    final appService = context.viewModel<AppEventService>();

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

    if (result == null) return;

    final account = await accountService.create(vo: result);
    appService.notify(EventAccountCreated(account));
  }

  Future<void> _addCategory(BuildContext context, ETransactionType type) async {
    final categoryService = context.service<DomainCategoryService>();
    final appService = context.viewModel<AppEventService>();

    final result = await BottomSheetComponent.show<CategoryVO?>(
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

    if (result == null) return;

    final category = await categoryService.create(vo: result);

    appService.notify(EventCategoryCreated(category));
  }

  Future<void> _addTag(BuildContext context) async {
    final tagService = context.service<DomainTagService>();
    final appService = context.viewModel<AppEventService>();

    final result = await BottomSheetComponent.show<TagVO>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return TagFormPage(keyboardHeight: bottom);
      },
    );

    if (result == null) return;

    final tag = await tagService.create(vo: result);

    appService.notify(EventTagCreated(tag));
  }
}
