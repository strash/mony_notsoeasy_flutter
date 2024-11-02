import "dart:ui";

import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/feed/page/view_model.dart";
import "package:mony_app/features/navbar/page/view.dart";
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

  bool _showPagination = true;

  void _pageListener() {
    setState(() => _showPagination = true);
    _subject.add(false);
  }

  @override
  void initState() {
    super.initState();

    _subject.debounceTime(const Duration(seconds: 1)).listen((e) {
      if (mounted) setState(() => _showPagination = e);
    });
  }

  @override
  void dispose() {
    _subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<FeedViewModel>();
    viewModel.pageController.addListener(_pageListener);

    return Positioned(
      top: MediaQuery.viewPaddingOf(context).top + 10.h,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: ClipSmoothRect(
          radius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 15.r, cornerSmoothing: 1.0),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: NavbarView.kSigma,
              sigmaY: NavbarView.kSigma,
            ),
            child: ColoredBox(
              color: theme.colorScheme.surfaceContainer.withOpacity(.5),
              child: SizedBox(
                width: 80.w,
                height: 30.h,
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
                              dotWidth: 7.r,
                              dotHeight: 7.r,
                              dotColor: theme.colorScheme.tertiaryContainer,
                              activeDotColor: theme.colorScheme.primary,
                              activeDotScale: 1.0,
                              spacing: 5.w,
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
                            width: 14.r,
                            height: 14.r,
                            colorFilter: ColorFilter.mode(
                              theme.colorScheme.onSurfaceVariant,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "поиск",
                            style: GoogleFonts.golosText(
                              fontSize: 13.sp,
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
