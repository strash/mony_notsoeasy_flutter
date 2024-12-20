import "dart:ui";

import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/constants.dart";
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
    final controller = viewModel.input;

    final smoothInputBorder = SmoothInputBorder(const Color(0x00FFFFFF));
    const fillColor = Color(0x00FFFFFF);

    final t = shrinkOffset.remap(.0, maxExtent * .15, .0, 1.0);
    const sigma = kTranslucentPanelBlurSigma;

    return Stack(
      fit: StackFit.expand,
      children: [
        // -> background
        ClipRect(
          child: RepaintBoundary(
            child: Opacity(
              opacity: t.clamp(.0, 1.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                child: ColoredBox(
                  color: theme.colorScheme.surface.withValues(
                    alpha: kTranslucentPanelOpacity,
                  ),
                ),
              ),
            ),
          ),
        ),

        // -> controls
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // -> textinput
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, .0, 10.0, .0),
                      child: SizedBox.fromSize(
                        size: const Size.fromHeight(40.0),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // -> background
                            ClipSmoothRect(
                              radius: const SmoothBorderRadius.all(
                                SmoothRadius(
                                  cornerRadius: 15.0,
                                  cornerSmoothing: 1.0,
                                ),
                              ),
                              child: RepaintBoundary(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: sigma,
                                    sigmaY: sigma,
                                  ),
                                  child: ColoredBox(
                                    color: theme.colorScheme.surfaceContainer
                                        .withValues(alpha: .7),
                                  ),
                                ),
                              ),
                            ),

                            // -> input
                            TextFormField(
                              key: controller.key,
                              focusNode: controller.focus,
                              controller: controller.controller,
                              validator: controller.validator,
                              onTapOutside: controller.onTapOutside,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.done,
                              maxLength: kMaxTitleLength,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              style: GoogleFonts.golosText(
                                color: theme.colorScheme.onSurface,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Assets.icons.magnifyingglass,
                                      width: 20.0,
                                      height: 20.0,
                                      colorFilter: ColorFilter.mode(
                                        theme.colorScheme.tertiary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 9.0,
                                ),
                                hintText: "поиск",
                                counterText: "",
                                filled: true,
                                fillColor: fillColor,
                                focusColor: fillColor,
                                hoverColor: fillColor,
                                border: smoothInputBorder,
                                disabledBorder: smoothInputBorder,
                                enabledBorder: smoothInputBorder,
                                errorBorder: smoothInputBorder,
                                focusedBorder: smoothInputBorder,
                                focusedErrorBorder: smoothInputBorder,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // -> button close
                  const CloseButtonComponent(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
