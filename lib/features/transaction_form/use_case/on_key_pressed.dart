import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/transaction_form/components/keyboard_button_type.dart";

final class OnKeyPressed
    extends UseCase<Future<void>, TransactionFormButtonType> {
  @override
  Future<void> call(
    BuildContext context, [
    TransactionFormButtonType? button,
  ]) async {
    if (button == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<TransactionFormViewModel>();
    final navigator = Navigator.of(context);

    final trimmedAmount = viewModel.amountNotifier.value.trim();
    switch (button) {
      // -> all other buttons
      case TransactionFormButtonTypeSymbol():
        if (trimmedAmount == "0" && button.value != ".") {
          viewModel.amountNotifier.value = button.value;
        } else {
          viewModel.amountNotifier.value = trimmedAmount + button.value;
        }

      // -> submit
      case TransactionFormButtonTypeAction():
        if (trimmedAmount.isEmpty) return;

        final parsedAmount = double.parse(trimmedAmount);
        final transactionVO = TransactionVO(
          amout: viewModel.typeController.value == ETransactionType.expense
              ? .0 - parsedAmount
              : parsedAmount,
          date: DateTime(
            viewModel.dateController.value!.year,
            viewModel.dateController.value!.month,
            viewModel.dateController.value!.day,
            viewModel.timeController.value.hour,
            viewModel.timeController.value.minute,
            viewModel.dateController.value!.second,
          ),
          note: viewModel.noteInput.text.trim(),
          accountId: viewModel.accountController.value!.id,
          categoryId: switch (viewModel.typeController.value) {
            ETransactionType.expense =>
              viewModel.expenseCategoryController.value!.id,
            ETransactionType.income =>
              viewModel.incomeCategoryController.value!.id,
          },
        );
        final transactionFormVO = TransactionFormVO(
          transactionVO: transactionVO,
          tags: viewModel.attachedTags,
        );

        navigator.pop<TransactionFormVO>(transactionFormVO);
    }
  }
}
