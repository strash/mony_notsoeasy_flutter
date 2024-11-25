import "package:flutter/material.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/category_form/page/view_model.dart";

export "./view_model.dart";

class CategoryFormPage extends StatelessWidget {
  final double keyboardHeight;
  final ETransactionType transactionType;
  final CategoryVariant? category;
  final List<String> additionalUsedTitles;

  const CategoryFormPage({
    super.key,
    required this.keyboardHeight,
    required this.transactionType,
    required this.category,
    required this.additionalUsedTitles,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryFormViewModelBuilder(
      keyboardHeight: keyboardHeight,
      transactionType: transactionType,
      category: category,
      additionalUsedTitles: additionalUsedTitles,
    );
  }
}
