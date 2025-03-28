import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";

final class OnInfoPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final viewModel = context.viewModel<TransactionFormViewModel>();
    final prefService = context.service<DomainSharedPreferencesService>();

    final value = !viewModel.isKeyboardHintAccepted;
    await prefService.setNewTransactionKeyboardHint(value);

    viewModel.setProtectedState(() {
      viewModel.isKeyboardHintAccepted = value;
    });
  }
}
