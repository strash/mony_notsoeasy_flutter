import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/bottom_sheet/sheet.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/services/database/transaction.dart";
import "package:mony_app/domain/services/database/vo/vo.dart";
import "package:mony_app/features/feed/feed.dart";
import "package:mony_app/features/transaction_form/transaction_form.dart";
import "package:provider/provider.dart";

final class OnNavbarAddTransactionPressed
    extends UseCase<Future<void>, FeedViewModel> {
  @override
  Future<void> call(BuildContext context, [FeedViewModel? viewModel]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final transactionService = context.read<DomainTransactionService>();
    final appService = context.viewModel<AppEventService>();

    final page = viewModel.pages.elementAt(viewModel.currentPageIndex);
    AccountModel? account;
    if (page is FeedPageStateSingleAccount) account = page.account;

    final result = await BottomSheetComponent.show<TransactionFormVO?>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return TransactionFormPage(account: account);
      },
    );
    if (result == null) return;

    final model = await transactionService.create(
      vo: result.transactionVO,
      tags: result.tags,
    );
    if (model == null) return;

    // TODO: общий ивент создания транзакции и тегов. проверить другие места
    appService.notify(EventTransactionCreated(model));

    void action(TransactionTagVariantVO value) {
      TagModel? tag;
      for (final element in model.tags) {
        if (element.title == value.vo.title) {
          tag = element;
          break;
        }
      }
      if (tag != null) appService.notify(EventTagCreated(tag));
    }

    result.tags.whereType<TransactionTagVariantVO>().forEach(action);
  }
}
