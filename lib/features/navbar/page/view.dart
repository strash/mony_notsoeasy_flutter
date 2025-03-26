import "dart:ui";

import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/navbar/components/components.dart";
import "package:mony_app/features/navbar/navbar.dart";
import "package:rxdart/rxdart.dart";

class NavBarView extends StatelessWidget {
  static const double kTabHeight = 54.0;
  static const double kBottomMargin = 8.0;
  static const double kRadius = 20.0;
  static double bottomOffset(BuildContext context) =>
      MediaQuery.of(context).viewPadding.bottom +
      kBottomMargin * 2.0 +
      kTabHeight +
      50.0;

  const NavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final viewModel = context.viewModel<NavBarViewModel>();
    const hPadding = 30.0;
    final vPadding = viewPadding.bottom + kBottomMargin;

    return StreamBuilder<NavBarEvent>(
      stream: viewModel.subject.whereType<NavBarEventTabChanged>(),
      builder: (context, snapshot) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              // -> pages
              IndexedStack(
                index: viewModel.currentTab.index,
                children: ENavBarTabItem.values
                    .map((e) {
                      return NavigatorWrapper(
                        navigatorKey: viewModel.getNavigatorTabKey(e),
                        onGenerateRoute: (settings) {
                          return viewModel.onGenerateRoute(e, settings);
                        },
                      );
                    })
                    .toList(growable: false),
              ),

              // -> navbar
              Positioned(
                left: hPadding,
                right: hPadding,
                bottom: vPadding,
                child: SizedBox(
                  height: kTabHeight,
                  child: SeparatedComponent.list(
                    direction: Axis.horizontal,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 10.0);
                    },
                    children: [
                      // -> tabs
                      Expanded(
                        child: ClipSmoothRect(
                          radius: const SmoothBorderRadius.all(
                            SmoothRadius(
                              cornerRadius: kRadius,
                              cornerSmoothing: 0.6,
                            ),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: kTranslucentPanelBlurSigma,
                              sigmaY: kTranslucentPanelBlurSigma,
                              tileMode: TileMode.repeated,
                            ),
                            child: ColoredBox(
                              color: theme.colorScheme.surfaceContainerHigh
                                  .withValues(alpha: kTranslucentPanelOpacity),
                              child: Row(
                                children: ENavBarTabItem.values
                                    .map((e) {
                                      return Expanded(
                                        child: NavBarTabComponent(
                                          index: e.index,
                                        ),
                                      );
                                    })
                                    .toList(growable: false),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // -> button plus
                      const NavBarButtonPlusComponent(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
