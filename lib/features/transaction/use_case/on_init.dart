import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/services/database/account.dart";
import "package:mony_app/features/transaction/page/view_model.dart";

final class OnInit extends UseCase<Future<void>, TransactionViewModel> {
  @override
  Future<void> call(
    BuildContext context, [
    TransactionViewModel? viewModel,
  ]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final accountService = context.service<DomainAccountService>();
    final balance = await accountService.getBalance(
      id: viewModel.transaction.account.id,
    );
    viewModel.setProtectedState(() {
      viewModel.balance = balance;
    });
  }
}
