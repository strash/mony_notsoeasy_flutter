import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/services/database/account.dart";
import "package:mony_app/features/transaction/page/view_model.dart";
import "package:provider/provider.dart";

final class OnInit extends UseCase<Future<void>, TransactionViewModel> {
  @override
  Future<void> call(
    BuildContext context, [
    TransactionViewModel? viewModel,
  ]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final accountService = context.read<DomainAccountService>();
    final balance = await accountService.getBalance(
      id: viewModel.transaction.account.id,
    );
    viewModel.setProtectedState(() {
      viewModel.balance = balance;
    });
  }
}
