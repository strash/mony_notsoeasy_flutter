import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/category_form/page/view_model.dart";
import "package:provider/provider.dart";

final class OnSubmitCategoryPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final viewModel = context.viewModel<CategoryFormViewModel>();
    final categoryService = context.read<DomainCategoryService>();
    final transactionType = viewModel.transactionType;
    final categories = await categoryService.getAll(
      transactionType: transactionType,
    );
    final vo = CategoryVO(
      title: viewModel.titleController.text.trim(),
      colorName:
          viewModel.colorController.value?.name ?? EColorName.random().name,
      icon: viewModel.emojiController.text,
      sort: categories.length,
      transactionType: transactionType,
    );
    if (context.mounted) Navigator.of(context).pop<CategoryVO>(vo);
  }
}
