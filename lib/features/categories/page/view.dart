import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/category_with_context_menu/component.dart";
import "package:mony_app/components/empty_state/component.dart";
import "package:mony_app/features/categories/categories.dart";
import "package:mony_app/features/categories/components/add_button.dart";
import "package:mony_app/features/categories/use_case/use_case.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/i18n/strings.g.dart";

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  String get _keyPrefix => "categories";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<CategoriesViewModel>();
    final isEmpty = viewModel.categories.isEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        controller: viewModel.controller,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> app bar
          AppBarComponent(
            title: Text(context.t.features.categories.title),
            trailing: CategoriesAddButtonComponent(
              onTap: viewModel<OnMenuAddPressed>(),
            ),
          ),

          // -> empty state
          if (isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomOffset),
                child: EmptyStateComponent(color: theme.colorScheme.onSurface),
              ),
            )
          // -> categories
          else
            SliverPadding(
              padding: const EdgeInsets.only(top: 20.0),
              sliver: SliverList.separated(
                findChildIndexCallback: (key) {
                  final id = (key as ValueKey).value;
                  final index = viewModel.categories.indexWhere((e) {
                    return "${_keyPrefix}_${e.id}" == id;
                  });
                  return index != -1 ? index : null;
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 5.0);
                },
                itemCount: viewModel.categories.length,
                itemBuilder: (context, index) {
                  final item = viewModel.categories.elementAt(index);

                  return CategoryWithContextMenuComponent(
                    key: ValueKey<String>("${_keyPrefix}_${item.id}"),
                    category: item,
                    isColorsVisible: viewModel.isColorsVisible,
                    onTap: viewModel<OnCategoryPressed>(),
                    onMenuSelected:
                        viewModel<OnCategoryWithContextMenuSelected>(),
                  );
                },
              ),
            ),

          // -> bottom offset
          if (!isEmpty)
            SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
