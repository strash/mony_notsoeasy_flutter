import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/common/utils/input_controller/validators/tag_title.dart";
import "package:mony_app/domain/services/database/tag.dart";
import "package:mony_app/domain/services/database/vo/tag.dart";
import "package:mony_app/features/tag_form/page/view_model.dart";

final class OnInit extends UseCase<Future<void>, TagFormViewModel> {
  @override
  Future<void> call(BuildContext context, [TagFormViewModel? viewModel]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final tagService = context.service<DomainTagService>();
    final data = await tagService.getAll();

    final List<String> titles = [];

    if (viewModel.tag case TagVariantModel(:final model)) {
      titles.addAll(data.where((e) => e.id != model.id).map((e) => e.title));
    } else {
      titles.addAll(data.map((e) => e.title));
    }
    titles.addAll(viewModel.additionalUsedTitles);
    viewModel.titleController.addValidator(TagTitleValidator(titles: titles));
  }
}
