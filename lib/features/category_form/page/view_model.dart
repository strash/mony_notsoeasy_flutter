import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/utils/input_controller/controller.dart";
import "package:mony_app/components/color_picker/component.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/category_form/page/view.dart";

final class CategoryFormViewModelBuilder extends StatefulWidget {
  final double keyboardHeight;
  final CategoryVO? category;

  const CategoryFormViewModelBuilder({
    super.key,
    required this.keyboardHeight,
    this.category,
  });

  @override
  ViewModelState<CategoryFormViewModelBuilder> createState() =>
      CategoryFormViewModel();
}

final class CategoryFormViewModel
    extends ViewModelState<CategoryFormViewModelBuilder> {
  final titleController = InputController();
  final colorController = ColorPickerController(Palette().randomColor);

  bool isSubmitEnabled = false;

  void _listener() {
    setState(() {
      isSubmitEnabled = titleController.isValid &&
          titleController.text.trim().isNotEmpty &&
          colorController.value != null;
    });
  }

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    if (category != null) {
      titleController.text = category.title;
      colorController.value = category.color;
    }
    titleController.addListener(_listener);
    colorController.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _listener();
    });
  }

  @override
  void dispose() {
    titleController.removeListener(_listener);
    colorController.removeListener(_listener);

    titleController.dispose();
    colorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<CategoryFormViewModel>(
      viewModel: this,
      child: CategoryFormView(keyboardHeight: widget.keyboardHeight),
    );
  }
}
