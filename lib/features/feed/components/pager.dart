import "dart:async";
import "dart:ui";

import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:rxdart/rxdart.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";

class FeedPagerComponent extends StatefulWidget {
  const FeedPagerComponent({super.key});

  @override
  State<FeedPagerComponent> createState() => _FeedPagerComponentState();
}

class _FeedPagerComponentState extends State<FeedPagerComponent> {
  final _subject = BehaviorSubject<bool>.seeded(false);

  late final StreamSubscription<bool> _pageSub;

  bool _showPagination = true;

  void _pageListener() {
    setState(() => _showPagination = true);
    _subject.add(false);
  }

  void _onPageEvent(bool e) {
    if (mounted) setState(() => _showPagination = e);
  }

  @override
  void initState() {
    super.initState();
    const duration = Duration(seconds: 1);
    _pageSub = _subject.debounceTime(duration).listen(_onPageEvent);
  }

  @override
  void dispose() {
    _pageSub.cancel();
    _subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<FeedViewModel>();
    viewModel.pageController.addListener(_pageListener);

    return Positioned(
      top: MediaQuery.viewPaddingOf(context).top + 10.0,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: ClipSmoothRect(
          radius: const SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 15.0, cornerSmoothing: 1.0),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: kTranslucentPanelBlurSigma,
              sigmaY: kTranslucentPanelBlurSigma,
            ),
            child: ColoredBox(
              color: theme.colorScheme.surfaceContainer
                  .withOpacity(kTranslucentPanelOpacity),
              child: SizedBox(
                width: 80.0,
                height: 30.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // -> pagination
                    if (viewModel.pages.isNotEmpty)
                      AnimatedOpacity(
                        opacity: _showPagination ? 1.0 : .0,
                        duration: Durations.medium2,
                        curve: Curves.easeInOut,
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: viewModel.pageController,
                            count: viewModel.pages.length,
                            effect: ScrollingDotsEffect(
                              dotWidth: 7.0,
                              dotHeight: 7.0,
                              dotColor: theme.colorScheme.tertiaryContainer,
                              activeDotColor: theme.colorScheme.primary,
                              activeDotScale: 1.0,
                              spacing: 5.0,
                              strokeWidth: .0,
                            ),
                          ),
                        ),
                      ),

                    // -> icon search
                    AnimatedOpacity(
                      opacity: _showPagination ? .0 : 1.0,
                      duration: Durations.medium2,
                      curve: Curves.easeInOut,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Assets.icons.magnifyingglass,
                            width: 14.0,
                            height: 14.0,
                            colorFilter: ColorFilter.mode(
                              theme.colorScheme.onSurfaceVariant,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "поиск",
                            style: GoogleFonts.golosText(
                              fontSize: 13.0,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
