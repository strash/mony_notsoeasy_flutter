import "dart:ui";

import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/time/component.dart";
import "package:mony_app/components/time/time_proxy.dart";

class TimePopupComponent extends StatefulWidget {
  final TimeController controller;
  final VoidCallback onTapOutside;
  final Rect initialRect;

  const TimePopupComponent({
    super.key,
    required this.controller,
    required this.onTapOutside,
    required this.initialRect,
  });

  @override
  State<TimePopupComponent> createState() => _TimePopupComponentState();
}

class _TimePopupComponentState extends State<TimePopupComponent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  final _wheelSize = 200.0;

  void _animatiosStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) widget.onTapOutside();
  }

  void _onTapOutside() {
    if (_controller.status != AnimationStatus.reverse) _controller.reverse();
  }

  Rect get _wheelRect {
    const offset = 6.0;
    final size = MediaQuery.sizeOf(context);
    final init = widget.initialRect;
    final isOnRight = init.left + _wheelSize > size.width;
    final isOnTop = init.top + init.height + offset + _wheelSize > size.height;
    Rect rect = Rect.fromLTWH(init.left, init.top, _wheelSize, _wheelSize);
    if (isOnRight) rect = rect.shift(-Offset(_wheelSize - init.width, .0));
    if (!isOnTop) {
      rect = rect.shift(Offset(.0, init.height + offset));
    } else {
      rect = rect.shift(-Offset(.0, _wheelSize + offset));
    }
    return rect;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Durations.short3,
      vsync: this,
    );
    _animation = Tween<double>(begin: .0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);
    _controller.addStatusListener(_animatiosStatusListener);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_animatiosStatusListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final value = _animation.value;

          return Stack(
            fit: StackFit.expand,
            children: [
              // -> canceler
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _onTapOutside,
              ),

              // -> time proxy
              Positioned.fromRect(
                rect: widget.initialRect,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _onTapOutside,
                  child: ListenableBuilder(
                    listenable: widget.controller,
                    builder: (context, child) {
                      return TimeProxyComponent(
                        time: widget.controller.formattedValue,
                      );
                    },
                  ),
                ),
              ),

              // -> wheel
              Positioned.fromRect(
                rect: _wheelRect,
                child: Transform.scale(
                  scale: value.remap(.0, 1.0, .9, 1.0),
                  child: Opacity(
                    opacity: value,
                    child: RepaintBoundary(
                      child: ClipSmoothRect(
                        radius: const SmoothBorderRadius.all(
                          SmoothRadius(
                            cornerRadius: 20.0,
                            cornerSmoothing: 1.0,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: kTranslucentPanelBlurSigma,
                            sigmaY: kTranslucentPanelBlurSigma,
                          ),
                          child: ColoredBox(
                            color: theme.colorScheme.surfaceContainer
                                .withOpacity(kTranslucentPanelOpacity),
                            child: Stack(
                              children: [
                                // -> decal
                                Align(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: SizedBox.fromSize(
                                      size: const Size.fromHeight(40.0),
                                      child: DecoratedBox(
                                        decoration: ShapeDecoration(
                                          color: theme
                                              .colorScheme.tertiaryContainer
                                              .withOpacity(.5),
                                          shape: const SmoothRectangleBorder(
                                            borderRadius:
                                                SmoothBorderRadius.all(
                                              SmoothRadius(
                                                cornerRadius: 10.0,
                                                cornerSmoothing: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // -> colon
                                Align(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 6.0),
                                    child: Text(
                                      ":",
                                      style: GoogleFonts.golosText(
                                        textStyle: theme.textTheme.bodyMedium,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.none,
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),

                                // -> wheels
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                  ),
                                  child: Row(
                                    children: [
                                      // -> hours
                                      Expanded(
                                        child: TimeWheelComponent(
                                          widget.controller.value.hour,
                                          itemCount: 24,
                                          isLeft: true,
                                          offset: 36.0,
                                          offAxisFraction: -.4,
                                          onValueChanged:
                                              widget.controller.setHours,
                                        ),
                                      ),

                                      // -> minutes
                                      Expanded(
                                        child: TimeWheelComponent(
                                          widget.controller.value.minute,
                                          itemCount: 60,
                                          isLeft: false,
                                          offset: 36.0,
                                          offAxisFraction: .4,
                                          onValueChanged:
                                              widget.controller.setMinutes,
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
