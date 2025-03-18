import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/bottom_sheet/sheet.dart";
import "package:mony_app/domain/services/database/tag.dart";
import "package:mony_app/domain/services/database/vo/tag.dart";
import "package:mony_app/features/tag_form/page/view_model.dart";

final class OnAddTagPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final tagService = context.service<DomainTagService>();
    final appService = context.viewModel<AppEventService>();

    final result = await BottomSheetComponent.show<TagVO>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return TagFormPage(keyboardHeight: bottom);
      },
    );

    if (result == null) return;

    final tag = await tagService.create(vo: result);

    appService.notify(EventTagCreated(tag));
  }
}
