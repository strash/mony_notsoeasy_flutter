import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/navbar/components/components.dart";
import "package:mony_app/features/navbar/page/view_model.dart";

class NavBarView extends StatelessWidget {
  static const double kTabHeight = 56.0;

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
                children: List<Widget>.generate(NavBarTabItem.length, (index) {
                  return NavigatorView(
                    index: index,
                    pages: const [],
                  );
                }),
              ),

              // -> navbar
              Positioned(
                bottom: 0.0,
                child: SizedBox(
                  width: viewSize.width,
                  height: kTabHeight + viewPadding.bottom,
                  child: ColoredBox(
                    color: theme.colorScheme.surfaceContainerHighest,
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
