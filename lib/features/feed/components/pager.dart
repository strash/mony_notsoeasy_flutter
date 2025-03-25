import "dart:async";
import "dart:ui";

import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/features/feed/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";
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

  late final _viewModel = context.viewModel<FeedViewModel>();
  late final _openSearch = _viewModel<OnSearchPressed>();

  bool _showPagination = true;

  void _pageListener() {
    if (!mounted) return;
    setState(() => _showPagination = true);
    _subject.add(false);
  }

  void _onPageEvent(bool e) {
    if (mounted) setState(() => _showPagination = e);
  }

  @override
  void initState() {
    super.initState();
    _pageSub = _subject
        .debounceTime(const Duration(seconds: 2))
        .listen(_onPageEvent);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _viewModel.pageController.addListener(_pageListener);
    });
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

    return Positioned(
      top: MediaQuery.viewPaddingOf(context).top + 10.0,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openSearch.call(context),
          child: IgnorePointer(
            child: ClipSmoothRect(
              radius: const SmoothBorderRadius.all(
                SmoothRadius(cornerRadius: 16.0, cornerSmoothing: 0.6),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: kTranslucentPanelBlurSigma,
                  sigmaY: kTranslucentPanelBlurSigma,
                ),
                child: SizedBox(
                  width: 95.0,
                  height: 34.0,
                  child: ColoredBox(
                    color: theme.colorScheme.surfaceContainer.withValues(
                      alpha: kTranslucentPanelOpacity,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // -> pagination
                        if (_viewModel.pages.isNotEmpty)
                          AnimatedOpacity(
                            opacity: _showPagination ? 1.0 : .0,
                            duration: Durations.medium4,
                            curve: Curves.easeInOut,
                            child: Center(
                              child: SmoothPageIndicator(
                                controller: _viewModel.pageController,
                                count: _viewModel.pages.length,
                                effect: ScrollingDotsEffect(
                                  dotWidth: 8.0,
                                  dotHeight: 8.0,
                                  dotColor: theme.colorScheme.tertiaryContainer,
                                  activeDotColor: theme.colorScheme.primary,
                                  activeDotScale: 1.0,
                                  spacing: 6.0,
                                  strokeWidth: .0,
                                ),
                              ),
                            ),
                          ),

                        // -> search
                        AnimatedOpacity(
                          opacity: _showPagination ? .0 : 1.0,
                          duration: Durations.medium2,
                          curve: Curves.easeInOut,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // -> icon
                              SvgPicture.asset(
                                Assets.icons.magnifyingglass,
                                width: 15.0,
                                height: 15.0,
                                colorFilter: ColorFilter.mode(
                                  theme.colorScheme.tertiary,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 4.0),

                              // -> text
                              Text(
                                context.t.features.feed.button_search,
                                style: GoogleFonts.golosText(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  height: 1.0,
                                  color: theme.colorScheme.tertiary,
                                ),
                              ),
                              const SizedBox(width: 2.0),
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
        ),
      ),
    );
  }
}
