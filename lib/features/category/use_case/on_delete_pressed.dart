import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:provider/provider.dart";

final class OnDeletePressed extends UseCase<Future<void>, CategoryModel> {
  @override
  Future<void> call(BuildContext context, [CategoryModel? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final sharedPrefService = context.read<DomainSharedPreferencesService>();
    final shouldConfirm = await sharedPrefService.getSettingsConfirmCategory();

    if (!context.mounted) return;
    final EAlertResult? result;
    if (shouldConfirm) {
      result = await AlertComponet.show(
        context,
        title: const Text("Удаление категории"),
        description: const Text(
          "Вместе с категорией будут удалены все транзакции, связанные с "
          "этой категорией. Эту проверку можно отключить в настройках.",
        ),
      );
    } else {
      result = EAlertResult.ok;
    }

    if (!context.mounted || result == null) return;

    switch (result) {
      case EAlertResult.cancel:
        return;
      case EAlertResult.ok:
        final categoryService = context.read<DomainCategoryService>();
        final appService = context.viewModel<AppEventService>();

        await categoryService.delete(id: value.id);

        appService.notify(EventCategoryDeleted(value));
    }
  }
}
