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

    final viewModel = context.viewModel<SearchViewModel>();
    final controller = viewModel.input;
    final onClearPressed = viewModel<OnClearButtonPressed>();
    final onTabPressed = viewModel<OnTabPressed>();

    final smoothInputBorder = SmoothInputBorder(const Color(0x00FFFFFF));
    const fillColor = Color(0x00FFFFFF);

    const sigma = kTranslucentPanelBlurSigma;

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

                // TODO: добавить градиенты как в тегах
                // TODO: при выборе убедиться, что выбранный айтем находиться
                // полностью во вьюхе. скролить во вью при выборе, если не во
                // вью
                // TODO: открывать табы только если viewModel.isSearching
                // -> search tabs
                SizedBox(
                  height: _tabSectionHeight,
                  child: ListView.separated(
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

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onTabPressed(context, item),
                        child: Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: .0,
                              end: isActive ? 1.0 : .0,
                            ),
                            duration: Durations.short3,
                            builder: (context, value, child) {
                              return DecoratedBox(
                                decoration: ShapeDecoration(
                                  color: theme.colorScheme.tertiary
                                      .withValues(alpha: value),
                                  shape: const SmoothRectangleBorder(
                                    borderRadius: SmoothBorderRadius.all(
                                      SmoothRadius(
                                        cornerRadius: 12.0,
                                        cornerSmoothing: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 3.0,
                                  ),
                                  child: Text(
                                    item.description,
                                    style: GoogleFonts.golosText(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                      color: Color.lerp(
                                        theme.colorScheme.onSurface,
                                        theme.colorScheme.surface,
                                        value,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}