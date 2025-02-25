import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";
import "package:provider/provider.dart";

final class OnInit extends UseCase<Future<void>, AccountViewModel> {
  @override
  Future<void> call(BuildContext context, [AccountViewModel? viewModel]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final account = viewModel.account;
    final accountService = context.read<DomainAccountService>();

    final balances = await accountService.getBalance(id: account.id);
    if (balances == null) return;

    final count = await accountService.count();
    viewModel.setProtectedState(() {
      viewModel.balance = balances;
      viewModel.accountsCount = count;
    });
  }
}
