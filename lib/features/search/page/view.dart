import "dart:ui";

import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/close_button/component.dart";
import "package:mony_app/features/feed/components/pager.dart";
import "package:mony_app/features/search/page/view_model.dart";

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewSize = MediaQuery.sizeOf(context);

    final viewModel = context.viewModel<SearchViewModel>();
    final anim = viewModel.animation;
    final distance =
        anim.status == AnimationStatus.forward ? viewModel.distance : .0;
    final curvAnim = viewModel.curvedAnimation;
    final sigma = anim.value.remap(.0, 1.0, .0, kTranslucentPanelBlurSigma);
    final width = curvAnim.value
        .lerp(FeedPagerComponent.width + distance, viewSize.width - 30.0);
    final height =
        curvAnim.value.lerp(FeedPagerComponent.height + distance, 48.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        // -> background
        RepaintBoundary(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: ColoredBox(
              color: theme.colorScheme.surface.withOpacity(
                anim.value.remap(.0, 1.0, .0, kTranslucentPanelOpacity),
              ),
            ),
          ),
        ),

        Opacity(
          opacity: anim.value,
          child: CustomScrollView(
            slivers: [
              // -> appbar
              const AppBarComponent(
                showBackground: false,
                automaticallyImplyLeading: false,
                trailing: CloseButtonComponent(),
              ),

              // -> content
              SliverToBoxAdapter(
                child: Center(child: Text("Search")),
              ),
            ],
          ),
        ),

        // -> search field proxy
        Positioned(
          top: FeedPagerComponent.top(context) + distance,
          left: .0,
          right: .0,
          bottom: MediaQuery.viewPaddingOf(context).bottom + 10.0,
          child: Align(
            alignment: Alignment.lerp(
              Alignment.topCenter,
              Alignment.bottomCenter,
              curvAnim.value,
            )!,
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: ShapeDecoration(
                      shadows: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withOpacity(
                            curvAnim.value.remap(.0, 1.0, .0, .15),
                          ),
                          blurRadius: 10.0,
                          spreadRadius: -2.0,
                          offset: const Offset(.0, 2.0),
                          blurStyle: BlurStyle.outer,
                        ),
                      ],
                      shape: const SmoothRectangleBorder(
                        borderRadius: FeedPagerComponent.borderRadius,
                      ),
                    ),
                  ),
                  RepaintBoundary(
                    child: ClipSmoothRect(
                      radius: FeedPagerComponent.borderRadius,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: kTranslucentPanelBlurSigma,
                          sigmaY: kTranslucentPanelBlurSigma,
                        ),
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withOpacity(
                              kTranslucentPanelOpacity,
                            ),
                            shape: const SmoothRectangleBorder(
                              borderRadius: FeedPagerComponent.borderRadius,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
