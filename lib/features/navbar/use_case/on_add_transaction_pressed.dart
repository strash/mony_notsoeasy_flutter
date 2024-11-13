import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/transaction_form/page/page.dart";
import "package:provider/provider.dart";

final class OnAddTransactionPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final transactionService = context.read<DomainTransactionService>();
    final tagService = context.read<DomainTagService>();
    final appService = context.viewModel<AppEventService>();

    final result = await BottomSheetComponent.show<TransactionFormVO?>(
      context,
      builder: (context, bottom) {
        return const TransactionFormPage();
      },
    );
    if (result == null) return;

    final List<TagModel> tagModels = await Future.wait(
      result.tags.map((e) {
        return switch (e) {
          final TransactionFormTagVO tag => tagService.create(vo: tag.vo),
          final TransactionTagFormModel tag => Future.value(tag.model),
        };
      }),
    );

    final transactionModel = await transactionService.create(
      vo: result.toTransactionVO().copyWith(
            tags: tagModels
                .map((e) => TransactionTagVO(title: e.title, tagId: e.id))
                .toList(growable: false),
          ),
    );

    if (transactionModel != null) {
      appService.notify(
        EventTransactionCreated(
          sender: TransactionFormViewModel,
          transaction: transactionModel,
        ),
      );
    }
  }
}
