import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/appbar_button/component.dart";
import "package:mony_app/components/tag/component.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/tags/tags.dart";
import "package:mony_app/features/tags/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class TagsView extends StatelessWidget {
  const TagsView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<TagsViewModel>();
    final onAddTagPressed = viewModel<OnAddTagPressed>();
    final onTagPressed = viewModel<OnTagPressed>();

    return Scaffold(
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
              onTap: () => onAddTagPressed(context),
            ),
          ),

          // -> tags
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 25.0);
              },
              itemCount: viewModel.tags.length,
              itemBuilder: (context, index) {
                final item = viewModel.tags.elementAt(index);

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTagPressed(context, item),
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TagComponent(tag: item),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // -> bottom offset
          SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
