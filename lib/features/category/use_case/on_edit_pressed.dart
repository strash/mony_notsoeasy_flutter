import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/category_form/category_form.dart";
import "package:provider/provider.dart";

final class OnEditPressed extends UseCase<Future<void>, CategoryModel> {
  @override
  Future<void> call(BuildContext context, [CategoryModel? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final categoryService = context.read<DomainCategoryService>();
    final appService = context.viewModel<AppEventService>();

    final result = await BottomSheetComponent.show<CategoryVO>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return CategoryFormPage(
          keyboardHeight: bottom,
          transactionType: value.transactionType,
          category: CategoryVariantModel(model: value),
          additionalUsedTitles: const [],
        );
      },
    );

    if (!context.mounted || result == null) return;

    final category = await categoryService.update(
      model: value.copyWith(
        title: result.title,
        icon: result.icon,
        colorName: EColorName.from(result.colorName),
        transactionType: result.transactionType,
      ),
    );

    appService.notify(EventCategoryUpdated(category));
  }
}
