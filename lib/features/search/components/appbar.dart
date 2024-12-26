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
import "package:mony_app/features/search/components/gradient_tween.dart";
import "package:mony_app/features/search/components/tab.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:mony_app/features/search/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class SearchAppBarComponent extends StatelessWidget {
  static const double _tabSectionHeight = 36.0;

  static const double collapsedHeight = AppBarComponent.height;
  static const double maximizedHeight =
      AppBarComponent.height + _tabSectionHeight;

  const SearchAppBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewSize = MediaQuery.sizeOf(context);

    final viewModel = context.viewModel<SearchViewModel>();
    final controller = viewModel.input;
    final onClearPressed = viewModel<OnClearButtonPressed>();
    final onTabPressed = viewModel<OnTabPressed>();

    final smoothInputBorder = SmoothInputBorder(const Color(0x00FFFFFF));
    const fillColor = Color(0x00FFFFFF);

    const sigma = kTranslucentPanelBlurSigma;

    final stop = 30.0.remap(.0, viewSize.width, .0, 1.0);

    return ClipRect(
      child: RepaintBoundary(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: ColoredBox(
            color: theme.colorScheme.surface.withValues(
              alpha: kTranslucentPanelOpacity,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // -> safe area
                SizedBox(
                  height: MediaQuery.paddingOf(context).top,
                ),

                // -> textinput and button close
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // -> textinput
                    Flexible(
                      child: SizedBox.fromSize(
                        size: const Size.fromHeight(collapsedHeight),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 5.0,
                          ),
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
                                textCapitalization:
                                    TextCapitalization.sentences,
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
                                  prefixIcon: SizedBox.square(
                                    dimension: 20.0,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        Assets.icons.magnifyingglass,
                                        width: 20.0,
                                        height: 20.0,
                                        colorFilter: ColorFilter.mode(
                                          theme.colorScheme.primary,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                  suffixIcon: controller.text.trim().isNotEmpty
                                      ? GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => onClearPressed(context),
                                          child: SizedBox.square(
                                            dimension: 24.0,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                Assets.icons.xmarkCircleFill,
                                                width: 24.0,
                                                height: 24.0,
                                                colorFilter: ColorFilter.mode(
                                                  theme.colorScheme
                                                      .onSurfaceVariant,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : null,
                                  contentPadding: const EdgeInsets.symmetric(
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

                // TODO: при выборе убедиться, что выбранный айтем находиться
                // полностью во вьюхе. скролить во вью при выборе, если не во
                // вью
                // TODO: открывать табы только если viewModel.isSearching
                // -> search tabs
                ListenableBuilder(
                  listenable: viewModel.tabsScrollController,
                  child: SizedBox(
                    height: _tabSectionHeight,
                    child: ListView.separated(
                      controller: viewModel.tabsScrollController,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 5.0);
                      },
                      itemCount: ESearchTab.values.length,
                      itemBuilder: (context, index) {
                        final item = ESearchTab.values.elementAt(index);
                        final isActive = viewModel.activeTab == item;

                        return SearchTabComponent(
                          tab: item,
                          isActive: isActive,
                          onTap: onTabPressed,
                        );
                      },
                    ),
                  ),
                  builder: (context, child) {
                    final ready = viewModel.tabsScrollController.isReady;
                    final bool showLeft;
                    final bool showRight;
                    if (ready) {
                      final pos = viewModel.tabsScrollController.position;
                      showLeft = pos.extentBefore > .0;
                      showRight = pos.extentAfter > .0;
                    } else {
                      showLeft = false;
                      showRight = false;
                    }

                    return TweenAnimationBuilder<(Color, Color)>(
                      duration: Durations.short3,
                      tween: SearchGradientTween(
                        begin: (
                          const Color(0x00FFFFFF),
                          const Color(0x00FFFFFF),
                        ),
                        end: (
                          showLeft
                              ? const Color(0x00FFFFFF)
                              : const Color(0xFFFFFFFF),
                          showRight
                              ? const Color(0x00FFFFFF)
                              : const Color(0xFFFFFFFF),
                        ),
                      ),
                      child: child,
                      builder: (context, values, child) {
                        return ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                              stops: [.0, stop, 1.0 - stop, 1.0],
                              colors: [
                                values.$1,
                                const Color(0xFFFFFFFF),
                                const Color(0xFFFFFFFF),
                                values.$2,
                              ],
                            ).createShader(rect);
                          },
                          child: child,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
