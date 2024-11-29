import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";
import "package:provider/provider.dart";

final class OnEditPressed extends UseCase<Future<void>, TagModel> {
  @override
  Future<void> call(BuildContext context, [TagModel? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final tagService = context.read<DomainTagService>();
    final appService = context.viewModel<AppEventService>();

    final result = await BottomSheetComponent.show<TagVO>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return TagFormPage(
          keyboardHeight: bottom,
          tag: TagVariantModel(value),
          additionalUsedTitles: const [],
        );
      },
    );

    if (!context.mounted || result == null) return;

    final tag = await tagService.update(
      model: value.copyWith(title: result.title),
    );

    appService.notify(EventTagUpdated(tag));
  }
}
