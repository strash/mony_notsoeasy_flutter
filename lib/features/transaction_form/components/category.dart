import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";

class TransactionFormCategoryComponent extends StatelessWidget {
  const TransactionFormCategoryComponent({super.key});

  Widget _getCategory(BuildContext context, CategoryModel category) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final color =
        ex?.from(category.colorName).color ?? theme.colorScheme.onSurface;

    return Row(
      children: [
        // -> icon
        SizedBox.square(
          dimension: 36.r,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: color,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(cornerRadius: 10.r, cornerSmoothing: 1.0),
                ),
              ),
            ),
            child: Center(
              child: Text(
                category.icon,
                style: theme.textTheme.headlineSmall?.copyWith(height: .0),
              ),
            ),
          ),
        ),
        SizedBox(width: 7.w),

        // -> title
        Flexible(
          child: Text(
            category.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<TransactionFormViewModel>();

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
              activeEntryPadding: EdgeInsets.symmetric(horizontal: 7.w),
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
