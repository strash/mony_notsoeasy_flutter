import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/bottom_sheet/sheet.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/services/database/transaction.dart";
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

    final transactionModel = await transactionService.create(
      vo: result.transactionVO,
      tags: result.tags,
    );

    if (transactionModel != null) {
      appService.notify(EventTransactionCreated(transactionModel));
    }
  }
}
