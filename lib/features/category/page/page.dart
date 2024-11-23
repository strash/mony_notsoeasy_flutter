import "package:flutter/widgets.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/features/category/page/view_model.dart";

export "./view_model.dart";

class CategoryPage extends StatelessWidget {
  final CategoryModel category;

  const CategoryPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryViewModelBuilder(category: category);
  }
}
