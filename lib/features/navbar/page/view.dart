import "dart:ui";

import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/navbar/components/components.dart";
import "package:mony_app/features/navbar/navbar.dart";
import "package:rxdart/rxdart.dart";

class NavbarView extends StatelessWidget {
  static final double kTabHeight = 54.h;
  static final double kBottomMargin = 8.r;
  static const double kSigma = 18.0;
  static final double kRadius = 20.r;

  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final viewModel = context.viewModel<NavbarViewModel>();
    final margin = viewPadding.bottom + kBottomMargin;

    return StreamBuilder<NavbarEvent>(
      stream: viewModel.subject.whereType<NavbarEventTabChanged>(),
      builder: (context, snapshot) {
        return Scaffold(
          body: Stack(
            children: [
              // -> pages
              IndexedStack(
                index: viewModel.currentTab.index,
                children: NavbarTabItem.values.map((e) {
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
                              sigmaX: kSigma,
                              sigmaY: kSigma,
                              tileMode: TileMode.repeated,
                            ),
                            child: ColoredBox(
                              color: theme.colorScheme.surfaceContainer
                                  .withOpacity(.6),
                              child: Row(
                                children: NavbarTabItem.values.map((e) {
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
