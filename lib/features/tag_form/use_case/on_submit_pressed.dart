import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/tag_form/tag_form.dart";

final class OnSubmitPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final viewModel = context.viewModel<TagFormViewModel>();
    final vo = TagVO(title: viewModel.titleController.text.trim());
    if (context.mounted) Navigator.of(context).pop<TagVO>(vo);
  }
}
