import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/navbar/components/components.dart";
import "package:mony_app/features/navbar/page/view_model.dart";

class NavBarView extends StatelessWidget {
  static final double kTabHeight = 56.h;

  const NavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<NavBarViewModel>(context);
    final theme = Theme.of(context);
    final viewSize = MediaQuery.sizeOf(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);

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
                            children:
                                List.generate(NavBarTabItem.length, (index) {
                              return Expanded(
                                child: NavBarTabComponent(
                                  index: index,
                                  height: kTabHeight,
                                ),
                              );
                            }),
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
