import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/alert/component.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/i18n/strings.g.dart";

final class OnDeleteDataPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final tr = context.t.features.settings.danger_zone.alert;

    final result = await AlertComponet.show(
      context,
      title: Text(tr.title),
      description: Text(tr.description),
    );

    if (!context.mounted || result == null) return;

    switch (result) {
      case EAlertResult.cancel:
        return;
      case EAlertResult.ok:
        final accountService = context.service<DomainAccountService>();
        final categoryService = context.service<DomainCategoryService>();
        final tagService = context.service<DomainTagService>();
        final transactionService = context.service<DomainTransactionService>();
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
