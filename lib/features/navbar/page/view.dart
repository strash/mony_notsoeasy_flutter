import "dart:ui";

import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/navbar/components/components.dart";
import "package:mony_app/features/navbar/navbar.dart";
import "package:rxdart/rxdart.dart";

class NavBarView extends StatelessWidget {
  static final double kTabHeight = 54.h;
  static final double kBottomMargin = 8.r;
  static final double kRadius = 20.r;
  static double bottomOffset(BuildContext context) =>
      MediaQuery.of(context).viewPadding.bottom +
      kBottomMargin * 2.0 +
      kTabHeight +
      50.h;

  const NavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final viewModel = context.viewModel<NavBarViewModel>();
    final margin = viewPadding.bottom + kBottomMargin;

    return StreamBuilder<NavBarEvent>(
      stream: viewModel.subject.whereType<NavBarEventTabChanged>(),
      builder: (context, snapshot) {
        return Scaffold(
          body: Stack(
            children: [
              // -> pages
              IndexedStack(
                index: viewModel.currentTab.index,
                children: NavBarTabItem.values.map((e) {
                  return NavigatorWrapper(
                    navigatorKey: viewModel.getNavigatorTabKey(e),
                    onGenerateRoute: (settings) {
                      return viewModel.onGenerateRoute(e, settings);
                    },
                  );
                }).toList(growable: false),
              ),

              // -> navbar
              Positioned(
                left: margin,
                right: margin,
                bottom: margin,
                child: SizedBox(
                  height: kTabHeight,
                  child: Row(
                    children: [
                      // -> tabs
                      Expanded(
                        child: ClipSmoothRect(
                          radius: SmoothBorderRadius.all(
                            SmoothRadius(
                              cornerRadius: kRadius,
                              cornerSmoothing: 1.0,
                            ),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: kTranslucentPanelBlurSigma,
                              sigmaY: kTranslucentPanelBlurSigma,
                              tileMode: TileMode.repeated,
                            ),
                            child: ColoredBox(
                              color: theme.colorScheme.surfaceContainer
                                  .withOpacity(kTranslucentPanelOpacity),
                              child: Row(
                                children: NavBarTabItem.values.map((e) {
                                  return Expanded(
                                    child: NavBarTabComponent(index: e.index),
                                  );
                                }).toList(growable: false),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 10.w),

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
