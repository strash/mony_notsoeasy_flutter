import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/utils/input_controller/controller.dart";
import "package:mony_app/components/color_picker/component.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/category_form/page/view.dart";
import "package:mony_app/features/category_form/use_case/use_case.dart";

export "../use_case/use_case.dart";

final class CategoryFormViewModelBuilder extends StatefulWidget {
  final double keyboardHeight;
  final ETransactionType transactionType;
  final CategoryVO? category;

  const CategoryFormViewModelBuilder({
    super.key,
    required this.keyboardHeight,
    required this.transactionType,
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
  final emojiController = InputController();

  bool isSubmitEnabled = false;

  ETransactionType get transactionType => widget.transactionType;

  void _listener() {
    setState(() {
      isSubmitEnabled = titleController.isValid &&
          titleController.text.trim().isNotEmpty &&
          colorController.value != null &&
          emojiController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    if (category != null) {
      titleController.text = category.title;
      colorController.value = category.color;
      emojiController.text = category.icon.isNotEmpty ? category.icon : "😀";
    } else {
      emojiController.text = "😀";
    }
    titleController.addListener(_listener);
    colorController.addListener(_listener);
    emojiController.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _listener();
    });
  }

  @override
  void dispose() {
    titleController.removeListener(_listener);
    colorController.removeListener(_listener);
    emojiController.removeListener(_listener);

    titleController.dispose();
    colorController.dispose();
    emojiController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<CategoryFormViewModel>(
      viewModel: this,
      useCases: [
        () => OnSubmitCategoryPressed(),
      ],
      child: CategoryFormView(keyboardHeight: widget.keyboardHeight),
    );
  }
}
