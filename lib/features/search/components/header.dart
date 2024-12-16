import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class SearchHeaderComponent extends StatelessWidget {
  const SearchHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _HeaderDelegate(
        viewPadding: MediaQuery.paddingOf(context),
      ),
    );
  }
}

final class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final EdgeInsets viewPadding;

  _HeaderDelegate({required this.viewPadding});

  @override
  double get minExtent => viewPadding.top + AppBarComponent.height;

  @override
  double get maxExtent => viewPadding.top + AppBarComponent.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<SearchViewModel>();
    final navigator = Navigator.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, .0, 10.0, .0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // -> tabs
              TabGroupComponent(
                values: ESearchTab.values,
                controller: viewModel.tabController,
              ),

              // -> button close
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: navigator.maybePop<void>,
                child: SizedBox.square(
                  dimension: 40.0,
                  child: Center(
                    child: SizedBox.square(
                      dimension: 30.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainer,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.icons.xmarkSemibold,
                            width: 20.0,
                            height: 20.0,
                            colorFilter: ColorFilter.mode(
                              theme.colorScheme.onSurface,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
