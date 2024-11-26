part of "./picker.dart";

final class _CategoryView extends CategoryView {
  const _CategoryView(
    super.config,
    super.state,
    super.tabController,
    super.pageController,
  );

  @override
  State<StatefulWidget> createState() => _CategoryViewState();
}

final class _CategoryViewState extends State<_CategoryView> {
  double pageIndex = .0;

  void _pageListener() {
    final pageController = widget.pageController;
    if (!pageController.isReady || pageController.page == null) return;
    setState(() => pageIndex = pageController.page!);
  }

  double _getT(int index) {
    final pageController = widget.pageController;
    if (!pageController.isReady || pageController.page == null) return .0;
    final idx = index.toDouble();
    final (begin, end) = (idx - 1.0, idx + 1.0);
    if (pageIndex < begin || end < pageIndex) return .0;
    if (begin <= pageIndex && pageIndex <= idx) {
      return pageIndex.remap(begin, idx, .0, 1.0);
    }
    if (idx <= pageIndex && pageIndex <= end) {
      return pageIndex.remap(idx, end, 1.0, .0);
    }
    return .0;
  }

  void _onTap(int index) {
    final pageController = widget.pageController;
    if (!pageController.isReady) return;
    pageController.animateToPage(
      index,
      duration: Durations.long4,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void didUpdateWidget(covariant _CategoryView oldWidget) {
    if (widget.config != oldWidget.config) pageIndex = .0;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (!widget.pageController.isReady) return;
      widget.pageController.addListener(_pageListener);
      setState(() => pageIndex = .0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final iconSize =
              constraints.maxWidth / max(widget.config.emojiSet.length, 1.0);
          final svgSize = iconSize * 0.65;

          return SizedBox.fromSize(
            size: Size.fromHeight(iconSize),
            child: Stack(
              children: [
                // -> active icon marker
                Positioned(
                  left: pageIndex * iconSize,
                  child: SizedBox.square(
                    dimension: iconSize,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                  ),
                ),

                // -> icons
                Center(
                  child: Row(
                    children: widget.config.emojiSet.indexed.map((e) {
                      final (index, emojiSet) = e;

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _onTap(index),
                        child: SizedBox.square(
                          dimension: iconSize,
                          child: Center(
                            child: SvgPicture.asset(
                              switch (emojiSet.category) {
                                Category.RECENT => Assets.icons.emojiResent,
                                Category.SMILEYS => Assets.icons.emojiSmiley,
                                Category.ANIMALS => Assets.icons.emojiAnimal,
                                Category.FOODS => Assets.icons.emojiFood,
                                Category.ACTIVITIES =>
                                  Assets.icons.emojiActivity,
                                Category.TRAVEL => Assets.icons.emojiTravel,
                                Category.OBJECTS => Assets.icons.emojiObject,
                                Category.SYMBOLS => Assets.icons.emojiSymbol,
                                Category.FLAGS => Assets.icons.emojiFlag,
                              },
                              width: svgSize,
                              height: svgSize,
                              colorFilter: ColorFilter.mode(
                                Color.lerp(
                                  theme.colorScheme.onSurfaceVariant,
                                  theme.colorScheme.onSurface,
                                  _getT(index),
                                )!,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(growable: false),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
