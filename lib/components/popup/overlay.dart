import "dart:ui";

import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/popup/button.dart";

class PopupOverlayComponent extends StatefulWidget {
  final VoidCallback onTapOutside;
  final Rect initialRect;
  final bool showBackground;
  final bool blurBackground;
  final TPopupButtonProxyBuilder proxyBuilder;
  final TPopupBuilder popupBuilder;

  const PopupOverlayComponent({
    super.key,
    required this.onTapOutside,
    required this.initialRect,
    required this.showBackground,
    required this.blurBackground,
    required this.proxyBuilder,
    required this.popupBuilder,
  });

  @override
  State<PopupOverlayComponent> createState() => _PopupOverlayComponentState();
}

class _PopupOverlayComponentState extends State<PopupOverlayComponent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  void _animatiosStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) widget.onTapOutside();
  }

  void _onTapOutside() {
    if (_controller.status != AnimationStatus.reverse) _controller.reverse();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Durations.short3,
      vsync: this,
    );
    _animation = Tween<double>(begin: .0, end: 1.0)
        .chain(CurveTween(curve: Curves.fastOutSlowIn))
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

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _animation.value;
        final sigma =
            value.remap(.0, 1.0, .0, widget.blurBackground ? 8.0 : .0);
        final bgAlpha =
            value.remap(.0, 1.0, .0, widget.showBackground ? .5 : .0);

        return Stack(
          fit: StackFit.expand,
          children: [
            // -> canceler
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _onTapOutside,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                child: ColoredBox(
                  color: theme.colorScheme.scrim.withValues(alpha: bgAlpha),
                ),
              ),
            ),

            // -> proxy
            Builder(
              builder: (context) {
                return widget.proxyBuilder(
                  context,
                  value,
                  widget.initialRect,
                  _onTapOutside,
                );
              },
            ),

            // -> popup
            Builder(
              builder: (context) {
                return widget.popupBuilder(
                  context,
                  value,
                  widget.initialRect,
                  _onTapOutside,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
