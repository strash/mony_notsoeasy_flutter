import "package:flutter/widgets.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/category/page/view.dart";
import "package:mony_app/features/category/use_case/use_case.dart";

final class CategoryViewModelBuilder extends StatefulWidget {
  final CategoryModel category;

  const CategoryViewModelBuilder({
    super.key,
    required this.category,
  });

  @override
  ViewModelState<CategoryViewModelBuilder> createState() => CategoryViewModel();
}

final class CategoryViewModel extends ViewModelState<CategoryViewModelBuilder> {
  late CategoryModel category = widget.category;

  CategoryBalanceModel? balance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      await OnInit().call(context, this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<CategoryViewModel>(
      viewModel: this,
      child: const CategoryView(),
    );
  }
}
