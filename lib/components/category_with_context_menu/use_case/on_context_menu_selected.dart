import "package:flutter/widgets.dart" show BuildContext, Text;
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/components/alert/component.dart";
import "package:mony_app/components/bottom_sheet/sheet.dart";
import "package:mony_app/components/category_with_context_menu/component.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/domain/services/database/category.dart";
import "package:mony_app/domain/services/database/vo/category.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/category_form/page/view_model.dart";
import "package:mony_app/i18n/strings.g.dart";

typedef TCategoryContextMenuValue =
    ({ECategoryContextMenuItem menu, CategoryModel category});

final class OnCategoryWithContextMenuSelected
    extends UseCase<Future<void>, TCategoryContextMenuValue> {
  @override
  Future<void> call(
    BuildContext context, [
    TCategoryContextMenuValue? value,
  ]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:menu, :category) = value;
    final categoryService = context.service<DomainCategoryService>();
    final appService = context.viewModel<AppEventService>();
    final sharedPrefService = context.service<DomainSharedPreferencesService>();
    final tr = context.t.components.category_with_context_menu;
    final shouldConfirm = await sharedPrefService.getSettingsConfirmCategory();

    switch (menu) {
      // -> edit
      case ECategoryContextMenuItem.edit:
        final result = await BottomSheetComponent.show<CategoryVO>(
          // ignore: use_build_context_synchronously
          context,
          showDragHandle: false,
          builder: (context, bottom) {
            return CategoryFormPage(
              keyboardHeight: bottom,
              transactionType: category.transactionType,
              category: CategoryVariantModel(model: category),
              additionalUsedTitles: const [],
            );
          },
        );
        if (result == null) return;
        final model = await categoryService.update(
          model: category.copyWith(
            title: result.title,
            icon: result.icon,
            colorName: EColorName.from(result.colorName),
            transactionType: result.transactionType,
          ),
        );
        appService.notify(EventCategoryUpdated(model));

      // -> delete
      case ECategoryContextMenuItem.delete:
        final EAlertResult? result;
        if (shouldConfirm) {
          result = await AlertComponet.show(
            // ignore: use_build_context_synchronously
            context,
            title: Text(tr.delete_alert.title),
            description: Text(tr.delete_alert.description),
          );
        } else {
          result = EAlertResult.ok;
        }
        if (result == null) return;
        switch (result) {
          case EAlertResult.cancel:
            return;
          case EAlertResult.ok:
            await categoryService.delete(id: category.id);
            appService.notify(EventCategoryDeleted(category));
        }
    }
  }
}
