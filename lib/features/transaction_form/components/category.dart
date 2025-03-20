import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";
import "package:mony_app/i18n/strings.g.dart";

class TransactionFormCategoryComponent extends StatelessWidget {
  const TransactionFormCategoryComponent({super.key});

  Widget _getCategory(
    BuildContext context,
    CategoryModel category,
    bool isColorsVisible,
  ) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final color =
        ex?.from(category.colorName).color ?? theme.colorScheme.onSurface;

    return Row(
      children: [
        // -> icon
        SizedBox.square(
          dimension: 36.0,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color:
                  isColorsVisible ? color : theme.colorScheme.surfaceContainer,
              shape: Smooth.border(
                10.0,
                isColorsVisible
                    ? BorderSide.none
                    : BorderSide(color: theme.colorScheme.outlineVariant),
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
        const SizedBox(width: 7.0),

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

        return SelectComponent<CategoryModel>(
          controller: switch (type) {
            ETransactionType.expense => viewModel.expenseCategoryController,
            ETransactionType.income => viewModel.incomeCategoryController,
          },
          placeholder: Text(
            context.t.features.transaction_form.category_select_placeholder,
          ),
          activeEntryPadding: const EdgeInsets.symmetric(horizontal: 7.0),
          activeEntry: (controller) {
            return controller.value != null
                ? Builder(
                  builder: (context) {
                    return _getCategory(
                      context,
                      controller.value!,
                      viewModel.isColorsVisible,
                    );
                  },
                )
                : null;
          },
          entryBuilder: (context) {
            return switch (type) {
                  ETransactionType.expense => viewModel.categories[type],
                  ETransactionType.income => viewModel.categories[type],
                }!
                .map((e) {
                  return SelectEntryComponent<CategoryModel>(
                    value: e,
                    equal: (lhs, rhs) => lhs != null && lhs.id == rhs.id,
                    child: Builder(
                      builder: (context) {
                        return _getCategory(
                          context,
                          e,
                          viewModel.isColorsVisible,
                        );
                      },
                    ),
                  );
                })
                .toList(growable: false);
          },
        );
      },
    );
  }
}
