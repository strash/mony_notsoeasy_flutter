import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";
import "package:provider/provider.dart";

final class OnInitAccount extends UseCase<Future<void>, AccountModel> {
  @override
  Future<void> call(BuildContext context, [AccountModel? account]) async {
    if (account == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<AccountViewModel>();
    final accountService = context.read<DomainAccountService>();

    final balances = await accountService.getBalances(ids: [account.id]);
    if (balances.isEmpty) return;

    viewModel.setProtectedState(() {
      viewModel.balance = balances.first;
    });
  }
}
