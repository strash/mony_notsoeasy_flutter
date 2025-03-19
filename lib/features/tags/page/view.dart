import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/appbar_button/component.dart";
import "package:mony_app/components/empty_state/component.dart";
import "package:mony_app/components/tag_with_context_menu/component.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/tags/tags.dart";
import "package:mony_app/features/tags/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class TagsView extends StatelessWidget {
  const TagsView({super.key});

  String get _keyPrefix => "tags";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<TagsViewModel>();
    final isEmpty = viewModel.tags.isEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        controller: viewModel.controller,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> appbar
          AppBarComponent(
            title: const Text("Теги"),
            trailing: AppBarButtonComponent(
              icon: Assets.icons.plus,
              onTap: () => viewModel<OnAddTagPressed>()(context),
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
          // -> tags
          else
            SliverPadding(
              padding: const EdgeInsets.only(top: 20.0),
              sliver: SliverList.separated(
                findChildIndexCallback: (key) {
                  final id = (key as ValueKey).value;
                  final index = viewModel.tags.indexWhere((e) {
                    return "${_keyPrefix}_${e.id}" == id;
                  });
                  return index != -1 ? index : null;
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 5.0);
                },
                itemCount: viewModel.tags.length,
                itemBuilder: (context, index) {
                  final item = viewModel.tags.elementAt(index);

                  return TagWithContextMenuComponent(
                    key: ValueKey<String>("${_keyPrefix}_${item.id}"),
                    tag: item,
                    onTap: viewModel<OnTagPressed>(),
                    onMenuSelected: viewModel<OnTagWithContextMenuSelected>(),
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
