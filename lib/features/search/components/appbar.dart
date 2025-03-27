import "dart:ui";

import "package:flutter/material.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/search/components/components.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:mony_app/features/search/use_case/use_case.dart";

class SearchAppBarComponent extends StatefulWidget {
  const SearchAppBarComponent({super.key});

  @override
  State<SearchAppBarComponent> createState() => _SearchAppBarComponentState();
}

class _SearchAppBarComponentState extends State<SearchAppBarComponent>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this,
    duration: Durations.short3,
  );

  @override
  void didChangeDependencies() {
    if (context.viewModel<SearchViewModel>().isSearching) {
      if (controller.status != AnimationStatus.forward) controller.forward();
    } else {
      if (controller.status != AnimationStatus.reverse) controller.reverse();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SliverPersistentHeader(
          pinned: true,
          delegate: _SearchAppBarDelegate(
            t: Curves.easeInOutSine.transform(controller.value),
            viewPadding: MediaQuery.viewPaddingOf(context),
          ),
        );
      },
    );
  }
}

class _SearchAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double t;
  final EdgeInsets viewPadding;

  final double _tabSectionHeight = 48.0;

  _SearchAppBarDelegate({required this.t, required this.viewPadding});

  double get _collapsedHeight {
    return AppBarComponent.height + 8.0;
  }

  double get _maximizedHeight {
    return _collapsedHeight + _tabSectionHeight * t;
  }

  @override
  double get minExtent {
    return viewPadding.top + _maximizedHeight;
  }

  @override
  double get maxExtent {
    return viewPadding.top + _maximizedHeight;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is _SearchAppBarDelegate &&
        (t != oldDelegate.t || viewPadding != oldDelegate.viewPadding);
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final viewSize = MediaQuery.sizeOf(context);

    final viewModel = context.viewModel<SearchViewModel>();
    final controller = viewModel.input;

    const sigma = kTranslucentPanelBlurSigma;

    final bgOpacity = shrinkOffset
        .remap(.0, maxExtent * .15, .0, 1.0)
        .clamp(.0, 1.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        // -> background
        ClipRect(
          child: RepaintBoundary(
            child: Opacity(
              opacity: bgOpacity,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                child: ColoredBox(
                  color: ColorScheme.of(
                    context,
                  ).surface.withValues(alpha: kTranslucentPanelOpacity),
                ),
              ),
            ),
          ),
        ),

        // -> search tabs
        Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(
              Size(viewSize.width, _tabSectionHeight),
            ),
            child: Opacity(
              opacity: t,
              child: SearchTabsComponent(height: _tabSectionHeight),
            ),
          ),
        ),

        // -> textinput and button close
        Positioned(
          top: viewPadding.top,
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(
              Size(viewSize.width, _collapsedHeight),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // -> textinput
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
                    child: SearchAppBarInputComponent(
                      controller: controller,
                      onClearInputPressed: viewModel<OnClearButtonPressed>(),
                    ),
                  ),
                ),

                // -> button close
                const CloseButtonComponent(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
