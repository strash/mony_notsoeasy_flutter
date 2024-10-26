import "package:flutter/material.dart";
import "package:mony_app/domain/services/vo/category.dart";
import "package:mony_app/features/category_form/page/view_model.dart";

export "./view_model.dart";

class CategoryFormPage extends StatelessWidget {
  final double keyboardHeight;
  final CategoryVO? category;

  const CategoryFormPage({
    super.key,
    required this.keyboardHeight,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryFormViewModelBuilder(
      keyboardHeight: keyboardHeight,
      category: category,
    );
  }
}
