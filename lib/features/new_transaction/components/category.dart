import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/new_transaction/page/view_model.dart";

class NewTransactionCategoryComponent extends StatelessWidget {
  const NewTransactionCategoryComponent({super.key});

  Widget _getCategory(BuildContext context, CategoryModel category) {
    final theme = Theme.of(context);
    final style = DefaultTextStyle.of(context).style;
    final color = getCategoryColors(context, category.color);

    return Row(
      children: [
        // -> icon
        Text(
          category.icon,
          style: theme.textTheme.headlineSmall?.copyWith(
            height: .0,
          ),
        ),
        SizedBox(width: 10.w),

        // -> title
        Flexible(
          child: Text(
            category.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style.copyWith(
              fontWeight: FontWeight.w500,
              color: color.text,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<NewTransactionViewModel>();

    return ListenableBuilder(
      listenable: viewModel.typeController,
      builder: (context, child) {
        final type = viewModel.typeController.value;
        final controller = switch (type) {
          ETransactionType.expense => viewModel.expenseCategoryController,
          ETransactionType.income => viewModel.incomeCategoryController,
        };

        return ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            return SelectComponent<CategoryModel>(
              controller: controller,
              placeholder: const Text("Категория"),
              activeEntry: controller.value != null
                  ? Builder(
                      builder: (context) {
                        return _getCategory(context, controller.value!);
                      },
                    )
                  : null,
              entryBuilder: (context) {
                return switch (type) {
                  ETransactionType.expense => viewModel.categories[type],
                  ETransactionType.income => viewModel.categories[type],
                }!
                    .map((e) {
                  return SelectEntryComponent<CategoryModel>(
                    value: e,
                    child: Builder(
                      builder: (context) {
                        return _getCategory(context, e);
                      },
                    ),
                  );
                }).toList(growable: false);
              },
            );
          },
        );
      },
    );
  }
}
