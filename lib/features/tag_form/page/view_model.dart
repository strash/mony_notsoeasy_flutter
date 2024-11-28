import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/domain/services/database/vo/tag.dart";
import "package:mony_app/features/tag_form/page/view.dart";

final class TagFormViewModelBuilder extends StatefulWidget {
  final double keyboardHeight;
  final TagVariant? tag;
  final List<String> additionalUsedTitles;

  const TagFormViewModelBuilder({
    super.key,
    required this.keyboardHeight,
    this.tag,
    required this.additionalUsedTitles,
  });

  @override
  ViewModelState<TagFormViewModelBuilder> createState() => TagFormViewModel();
}

final class TagFormViewModel extends ViewModelState<TagFormViewModelBuilder> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<TagFormViewModel>(
      viewModel: this,
      child: TagFormView(keyboardHeight: widget.keyboardHeight),
    );
  }
}
