import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/utils/input_controller/controller.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/category_form/page/view.dart";
import "package:mony_app/features/category_form/use_case/use_case.dart";
import "package:provider/provider.dart";

final class CategoryFormViewModelBuilder extends StatefulWidget {
  final double keyboardHeight;
  final ETransactionType transactionType;
  final CategoryVariant? category;
  final List<String> additionalUsedTitles;

  const CategoryFormViewModelBuilder({
    super.key,
    required this.keyboardHeight,
    required this.transactionType,
    required this.category,
    required this.additionalUsedTitles,
  });

  @override
  ViewModelState<CategoryFormViewModelBuilder> createState() =>
      CategoryFormViewModel();
}

final class CategoryFormViewModel
    extends ViewModelState<CategoryFormViewModelBuilder> {
  final titleController = InputController();
  final colorController = NamedColorPickerController(EColorName.random());
  final emojiController = InputController();

  bool isSubmitEnabled = false;

  ETransactionType get transactionType => widget.transactionType;

  final List<String> _titles = [];

  void _listener() {
    setState(() {
      isSubmitEnabled = titleController.isValid &&
          titleController.text.trim().isNotEmpty &&
          colorController.value != null &&
          emojiController.text.isNotEmpty;
    });
  }

  Future<void> _fetchData() async {
    final service = context.read<DomainCategoryService>();
    final data = await service.getAll(transactionType: widget.transactionType);
    if (widget.category case CategoryVariantModel(:final model)) {
      _titles.addAll(data.where((e) => e.id != model.id).map((e) => e.title));
    } else {
      _titles.addAll(data.map((e) => e.title));
    }
    _titles.addAll(widget.additionalUsedTitles);
    titleController.addValidator(CategoryTitleValidator(titles: _titles));
  }

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    if (category != null) {
      switch (category) {
        case CategoryVariantVO(:final vo):
          titleController.text = vo.title;
          colorController.value = EColorName.from(vo.colorName);
          emojiController.text = vo.icon.isNotEmpty ? vo.icon : "😀";
        case CategoryVariantModel(:final model):
          titleController.text = model.title;
          colorController.value = model.colorName;
          emojiController.text = model.icon.isNotEmpty ? model.icon : "😀";
      }
    } else {
      emojiController.text = "😀";
    }
    titleController.addListener(_listener);
    colorController.addListener(_listener);
    emojiController.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _listener();
      _fetchData();
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
