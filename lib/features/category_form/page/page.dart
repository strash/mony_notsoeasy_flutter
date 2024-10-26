import "package:flutter/material.dart";
import "package:mony_app/features/category_form/page/view_model.dart";

export "./view_model.dart";

class CategoryFormPage extends StatelessWidget {
  final double keyboardHeight;

  const CategoryFormPage({
    super.key,
    required this.keyboardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryFormViewModelBuilder(keyboardHeight: keyboardHeight);
  }
}
