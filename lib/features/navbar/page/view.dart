import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/navbar/components/components.dart";
import "package:mony_app/features/navbar/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class NavBarView extends StatelessWidget {
  static final double kTabHeight = 56.h;

  const NavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<NavBarViewModel>(context);
    final theme = Theme.of(context);
    final viewSize = MediaQuery.sizeOf(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final halfTabs = (NavBarTabItem.length * 0.5).toInt();

    return StreamBuilder<NavBarTabItem>(
      stream: viewModel.tabStream,
      builder: (context, snapshot) {
        return Scaffold(
          body: Stack(
            children: [
              // -> pages
              IndexedStack(
                index: viewModel.tab,
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
                bottom: 0.0,
                child: SizedBox(
                  width: viewSize.width,
                  height: kTabHeight + viewPadding.bottom,
                  child: ColoredBox(
                    color: theme.colorScheme.surface,
                    child: Column(
                      children: [
                        // -> tabs
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // -> left part
                              ...NavBarTabItem.values.take(halfTabs).map((e) {
                                return Expanded(
                                  child: NavBarTabComponent(
                                    index: e.index,
                                    height: kTabHeight,
                                  ),
                                );
                              }),

                              // -> button plus
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    viewModel.onAddExpensePressed(context);
                                  },
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.onSurface,
                                      borderRadius: SmoothBorderRadius.all(
                                        SmoothRadius(
                                          cornerRadius: 17.r,
                                          cornerSmoothing: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 18.w,
                                        vertical: 6.h,
                                      ),
                                      child: SvgPicture.asset(
                                        Assets.icons.plus,
                                        width: 32.r,
                                        height: 32.r,
                                        colorFilter: ColorFilter.mode(
                                          theme.colorScheme.surface,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // -> rigth part
                              ...NavBarTabItem.values.skip(halfTabs).map((e) {
                                return Expanded(
                                  child: NavBarTabComponent(
                                    index: e.index,
                                    height: kTabHeight,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        // -> safe area
                        SizedBox.fromSize(
                          size: Size.fromHeight(viewPadding.bottom),
                        ),
                      ],
                    ),
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
