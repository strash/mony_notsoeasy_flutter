import "dart:ui";

import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
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
  late final AnimationController _controller =
      AnimationController(duration: Durations.short3, vsync: this)
        ..addStatusListener(_statusListener)
        ..forward();

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      widget.onTapOutside();
    }
  }

  void _onTapOutside() {
    if (_controller.status != AnimationStatus.reverse) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_statusListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOutSine.transform(_controller.value);
        final sigma = widget.blurBackground ? 8.0 : .0;
        final alpha = widget.showBackground ? .3 : .0;
        final remappedSigma = t.remap(.0, 1.0, .0, sigma);
        final remappedAlpha = t.remap(.0, 1.0, .0, alpha);

        return Stack(
          fit: StackFit.expand,
          children: [
            // -> canceler
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _onTapOutside,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: remappedSigma,
                  sigmaY: remappedSigma,
                ),
                child: ColoredBox(
                  color: ColorScheme.of(
                    context,
                  ).scrim.withValues(alpha: remappedAlpha),
                ),
              ),
            ),

            // -> proxy
            widget.proxyBuilder(
              context,
              _controller.value,
              _controller.status,
              widget.initialRect,
              _onTapOutside,
            ),

            // -> popup
            widget.popupBuilder(
              context,
              _controller.value,
              _controller.status,
              widget.initialRect,
              _onTapOutside,
            ),
          ],
        );
      },
    );
  }
}
