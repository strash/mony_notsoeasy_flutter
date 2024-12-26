import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/search/components/components.dart";
import "package:mony_app/features/search/search.dart";
import "package:mony_app/features/search/use_case/on_tab_pressed.dart";

class SearchTabsComponent extends StatelessWidget {
  final double height;

  const SearchTabsComponent({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final viewSize = MediaQuery.sizeOf(context);
    final stop = 24.0.remap(.0, viewSize.width, .0, 1.0);
    const padding = EdgeInsets.symmetric(horizontal: 10.0);

    final viewModel = context.viewModel<SearchViewModel>();
    final onTabPressed = viewModel<OnTabPressed>();

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 5.0),
        child: ListenableBuilder(
          listenable: viewModel.tabsScrollController,
          child: ListView.separated(
            controller: viewModel.tabsScrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: padding,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 5.0);
            },
            itemCount: ESearchTab.values.length,
            itemBuilder: (context, index) {
              final item = ESearchTab.values.elementAt(index);
              final isActive = viewModel.activeTab == item;

              return SearchTabComponent(
                tab: item,
                isActive: isActive,
                padding: padding,
                onTap: onTabPressed,
              );
            },
          ),
          builder: (context, child) {
            final ready = viewModel.tabsScrollController.isReady;
            final bool showLeft;
            final bool showRight;
            if (ready) {
              final pos = viewModel.tabsScrollController.position;
              showLeft = pos.extentBefore > .0;
              showRight = pos.extentAfter > .0;
            } else {
              showLeft = false;
              showRight = false;
            }

            return TweenAnimationBuilder<(Color, Color)>(
              duration: Durations.short3,
              tween: SearchGradientTween(
                begin: (
                  const Color(0x00FFFFFF),
                  const Color(0x00FFFFFF),
                ),
                end: (
                  showLeft ? const Color(0x00FFFFFF) : const Color(0xFFFFFFFF),
                  showRight ? const Color(0x00FFFFFF) : const Color(0xFFFFFFFF),
                ),
              ),
              child: child,
              builder: (context, values, child) {
                return ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      stops: [.0, stop, 1.0 - stop, 1.0],
                      colors: [
                        values.$1,
                        const Color(0xFFFFFFFF),
                        const Color(0xFFFFFFFF),
                        values.$2,
                      ],
                    ).createShader(rect);
                  },
                  child: child,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
