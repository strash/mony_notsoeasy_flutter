import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/services/database/vo/tag.dart";
import "package:mony_app/features/features.dart";

final class OnEditPressed extends UseCase<Future<void>, TagModel> {
  @override
  Future<void> call(BuildContext context, [TagModel? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final result = await BottomSheetComponent.show<TagVO>(
      context,
      builder: (context, bottom) {
        return TagFormPage(
          keyboardHeight: bottom,
          tag: TagVariantModel(value),
        );
      },
    );

    if (!context.mounted || result == null) return;

    print(result);
  }
}
