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
import "package:smooth_page_indicator/smooth_page_indicator.dart";

class FeedPagerComponent extends StatelessWidget {
  const FeedPagerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<FeedViewModel>();

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
          // TODO: при переключении страниц показывать пэйджер и прятать поиск
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: NavbarView.kSigma,
              sigmaY: NavbarView.kSigma,
            ),
            child: ColoredBox(
              color: theme.colorScheme.surfaceContainer.withOpacity(.3),
              child: SizedBox(
                width: 80.w,
                height: 30.h,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // -> pagination
                    if (viewModel.pages.isNotEmpty)
                      Center(
                        child: SmoothPageIndicator(
                          controller: viewModel.pageController,
                          count: viewModel.pages.length,
                          effect: ScrollingDotsEffect(
                            dotWidth: 7.r,
                            dotHeight: 7.r,
                            dotColor: theme.colorScheme.tertiaryContainer,
                            activeDotColor: theme.colorScheme.tertiary,
                            activeDotScale: 1.0,
                            spacing: 5.w,
                            strokeWidth: .0,
                          ),
                        ),
                      ),

                    // -> icon search
                    Row(
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
