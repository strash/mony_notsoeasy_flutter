import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/new_transaction/page/view_model.dart";
import "package:provider/provider.dart";

final class OnKeyboardHintAccepted extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final viewModel = context.viewModel<NewTransactionViewModel>();

    final prefService = context.read<DomainSharedPrefenecesService>();

    final isKeyboardHintAccepted =
        await prefService.setIsNewTransactionKeyboardHintAccepted();

    viewModel.setProtectedState(() {
      viewModel.isKeyboardHintAccepted = isKeyboardHintAccepted;
    });
  }
}
