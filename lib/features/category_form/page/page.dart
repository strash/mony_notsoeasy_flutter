import "package:flutter/material.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/category_form/page/view_model.dart";

export "./view_model.dart";

class CategoryFormPage extends StatelessWidget {
  final double keyboardHeight;
  final ETransactionType transactionType;
  final CategoryVO? category;

  const CategoryFormPage({
    super.key,
    required this.keyboardHeight,
    required this.transactionType,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryFormViewModelBuilder(
      keyboardHeight: keyboardHeight,
      transactionType: transactionType,
      category: category,
    );
  }
}
