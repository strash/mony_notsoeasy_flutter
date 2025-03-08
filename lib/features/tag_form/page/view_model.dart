import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/utils/utils.dart";
import "package:mony_app/domain/services/database/vo/tag.dart";
import "package:mony_app/features/tag_form/page/view.dart";
import "package:mony_app/features/tag_form/use_case/use_case.dart";

final class TagFormPage extends StatefulWidget {
  final double keyboardHeight;
  final TagVariant? tag;
  final List<String> additionalUsedTitles;

  const TagFormPage({
    super.key,
    required this.keyboardHeight,
    this.tag,
    this.additionalUsedTitles = const [],
  });

  @override
  ViewModelState<TagFormPage> createState() => TagFormViewModel();
}

final class TagFormViewModel extends ViewModelState<TagFormPage> {
  final titleController = InputController();

  bool isSubmitEnabled = false;

  TagVariant? get tag {
    return widget.tag;
  }

  List<String> get additionalUsedTitles {
    return widget.additionalUsedTitles;
  }

  void _listener() {
    setProtectedState(() {
      isSubmitEnabled =
          titleController.isValid && titleController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    final tag = this.tag;
    if (tag != null) {
      switch (tag) {
        case TagVariantVO(:final vo):
          titleController.text = vo.title;
        case TagVariantModel(:final model):
          titleController.text = model.title;
      }
    }
    titleController.addListener(_listener);

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _listener();
      OnInit().call(context, this);
    });
  }

  @override
  void dispose() {
    titleController.removeListener(_listener);
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<TagFormViewModel>(
      viewModel: this,
      useCases: [() => OnSubmitPressed()],
      child: TagFormView(keyboardHeight: widget.keyboardHeight),
    );
  }
}
