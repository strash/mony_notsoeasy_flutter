import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/alert/component.dart";
import "package:mony_app/domain/domain.dart";
import "package:provider/provider.dart";

final class OnDeleteDataPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final result = await AlertComponet.show(
      context,
      title: const Text("Удаление данных"),
      description: const Text(
        "Точно удалить? Восстановить данные после удаления будет не возможно. "
        "Перед удалением стоит экспортировать данные.",
      ),
    );

    if (!context.mounted || result == null) return;

    switch (result) {
      case EAlertResult.cancel:
        return;
      case EAlertResult.ok:
        final accountService = context.read<DomainAccountService>();
        final categoryService = context.read<DomainCategoryService>();
        final tagService = context.read<DomainTagService>();
        final transactionService = context.read<DomainTransactionService>();
        final appService = context.viewModel<AppEventService>();

        await transactionService.purgeData();
        await tagService.purgeData();
        await categoryService.purgeData();
        await accountService.purgeData();

        await categoryService.createDefaultCategories();

        appService.notify(EventSettingsDataDeletionRequested());
    }
  }
}
