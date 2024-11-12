import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/new_transaction/components/keyboard_button_type.dart";
import "package:provider/provider.dart";

final class OnKeyPressed extends UseCase<Future<void>, ButtonType> {
  @override
  Future<void> call(BuildContext context, [ButtonType? button]) async {
    if (button == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<NewTransactionViewModel>();
    final transactionService = context.read<DomainTransactionService>();
    final tagService = context.read<DomainTagService>();
    final appService = context.viewModel<AppEventService>();

    final navigator = Navigator.of(context);

    final amount = viewModel.amountNotifier.value.trim();
    switch (button) {
      case ButtonTypeSymbol():
        if (amount == "0" && button.value != ".") {
          viewModel.amountNotifier.value = button.value;
        } else {
          viewModel.amountNotifier.value = amount + button.value;
        }
      case ButtonTypeAction():
        if (amount.isEmpty) return;

        final List<TagModel> tagModels = await Future.wait(
          viewModel.attachedTags.map((e) {
            return switch (e) {
              final NewTransactionTagVO tag => tagService.create(vo: tag.vo),
              final NewTransactionTagModel tag => Future.value(tag.model),
            };
          }),
        );

        final parsedAmount = double.parse(amount);
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
          tags: tagModels
              .map((e) => TransactionTagVO(title: e.title, tagId: e.id))
              .toList(growable: false),
        );

        final transactionModel = await transactionService.create(
          vo: transactionVO,
        );

        if (transactionModel == null) return;
        appService.notify(
          EventTransactionCreated(
            sender: NewTransactionViewModel,
            transaction: transactionModel,
          ),
        );

        navigator.pop();
    }
  }
}
