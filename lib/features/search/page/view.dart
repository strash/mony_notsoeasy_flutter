import "dart:ui";

import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/close_button/component.dart";
import "package:mony_app/features/feed/components/pager.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewSize = MediaQuery.sizeOf(context);

    final viewModel = context.viewModel<SearchViewModel>();
    final controller = viewModel.input;

    final anim = viewModel.animation;
    final distance =
        anim.status == AnimationStatus.forward ? viewModel.distance : .0;
    final curvAnim = viewModel.curvedAnimation;

    final sigma = anim.value.remap(.0, 1.0, .0, kTranslucentPanelBlurSigma);

    final width = curvAnim.value
        .lerp(FeedPagerComponent.width + distance, viewSize.width - 30.0);
    final height =
        curvAnim.value.lerp(FeedPagerComponent.height + distance, 48.0);
    final bottom = 15.0 + viewModel.keyboardHeight;

    final smoothInputBorder = SmoothInputBorder(const Color(0x00FFFFFF));
    const fillColor = Color(0x00FFFFFF);

    final color = Color.lerp(
      FeedPagerComponent.color(context),
      theme.colorScheme.surfaceContainerHighest
          .withOpacity(kTranslucentPanelOpacity),
      curvAnim.value,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: fillColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // -> background
          RepaintBoundary(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: ColoredBox(
                color: theme.colorScheme.surface.withOpacity(
                  anim.value.remap(.0, 1.0, .0, kTranslucentPanelOpacity),
                ),
              ),
            ),
          ),

          Opacity(
            opacity: anim.value,
            child: const CustomScrollView(
              slivers: [
                // -> appbar
                AppBarComponent(
                  showBackground: false,
                  automaticallyImplyLeading: false,
                  trailing: CloseButtonComponent(),
                ),

                // -> content
                SliverToBoxAdapter(
                  child: Center(child: Text("Search")),
                ),
              ],
            ),
          ),

          // -> search field
          Positioned(
            top: FeedPagerComponent.top(context) + distance,
            left: .0,
            right: .0,
            bottom: bottom,
            child: Align(
              alignment: Alignment.lerp(
                Alignment.topCenter,
                Alignment.bottomCenter,
                curvAnim.value,
              )!,
              child: SizedBox(
                width: width,
                height: height,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // -> shadow
                    DecoratedBox(
                      decoration: ShapeDecoration(
                        shadows: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(
                              curvAnim.value.remap(.0, 1.0, .0, .08),
                            ),
                            blurRadius: 18.0,
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                        shape: const SmoothRectangleBorder(
                          borderRadius: FeedPagerComponent.borderRadius,
                        ),
                      ),
                    ),

                    // -> background
                    RepaintBoundary(
                      child: ClipSmoothRect(
                        radius: FeedPagerComponent.borderRadius,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: kTranslucentPanelBlurSigma,
                            sigmaY: kTranslucentPanelBlurSigma,
                          ),
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              color: color,
                              shape: const SmoothRectangleBorder(
                                borderRadius: FeedPagerComponent.borderRadius,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // -> textinput
                    Opacity(
                      opacity: curvAnim.value,
                      child: TextFormField(
                        key: controller.key,
                        focusNode: controller.focus,
                        controller: controller.controller,
                        validator: controller.validator,
                        onTapOutside: controller.onTapOutside,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        maxLength: kMaxTitleLength,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        // autovalidateMode: AutovalidateMode.always,
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
                          hintText: "поиск",
                          counterText: "",
                          filled: false,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
