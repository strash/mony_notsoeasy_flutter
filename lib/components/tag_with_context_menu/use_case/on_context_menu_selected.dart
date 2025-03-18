import "package:flutter/widgets.dart" show BuildContext, Text;
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/components/alert/component.dart";
import "package:mony_app/components/bottom_sheet/sheet.dart";
import "package:mony_app/components/tag_with_context_menu/component.dart"
    show ETagContextMenuItem;
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/services/database/tag.dart";
import "package:mony_app/domain/services/database/vo/tag.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/tag_form/page/view_model.dart";

typedef TTagContextMenuValue = ({ETagContextMenuItem menu, TagModel tag});

final class OnTagWithContextMenuSelected
    extends UseCase<Future<void>, TTagContextMenuValue> {
  @override
  Future<void> call(BuildContext context, [TTagContextMenuValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:menu, :tag) = value;
    final tagService = context.service<DomainTagService>();
    final appService = context.viewModel<AppEventService>();
    final sharedPrefService = context.service<DomainSharedPreferencesService>();
    final shouldConfirm = await sharedPrefService.getSettingsConfirmTag();

    switch (menu) {
      // -> edit
      case ETagContextMenuItem.edit:
        final result = await BottomSheetComponent.show<TagVO>(
          // ignore: use_build_context_synchronously
          context,
          showDragHandle: false,
          builder: (context, bottom) {
            return TagFormPage(
              keyboardHeight: bottom,
              tag: TagVariantModel(tag),
            );
          },
        );
        if (result == null) return;
        final model = await tagService.update(
          model: tag.copyWith(title: result.title),
        );
        appService.notify(EventTagUpdated(model));

      // -> delete
      case ETagContextMenuItem.delete:
        final EAlertResult? result;
        if (shouldConfirm) {
          result = await AlertComponet.show(
            // ignore: use_build_context_synchronously
            context,
            title: const Text("Удаление тега"),
            description: const Text(
              "Тег просто будет отвязан от всех транзакций, к которым он "
              "привязан. Эту проверку можно отключить в настройках.",
            ),
          );
        } else {
          result = EAlertResult.ok;
        }
        if (result == null) return;
        switch (result) {
          case EAlertResult.cancel:
            return;
          case EAlertResult.ok:
            await tagService.delete(id: tag.id);
            appService.notify(EventTagDeleted(tag));
        }
    }
  }
}
