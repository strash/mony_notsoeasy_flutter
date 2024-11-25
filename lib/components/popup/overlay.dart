import "package:flutter/material.dart";

class PopupOverlayComponent extends StatefulWidget {
  final VoidCallback onTapOutside;
  final Rect initialRect;
  final WidgetBuilder proxyBuilder;
  final Widget Function(
    BuildContext context,
    double animation,
    Rect proxyRect,
    VoidCallback dismiss,
  ) popupBuilder;

  const PopupOverlayComponent({
    super.key,
    required this.onTapOutside,
    required this.initialRect,
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
    return AnimatedBuilder(
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

            // -> proxy
            Positioned.fromRect(
              rect: widget.initialRect,
              child: GestureDetector(
                onTap: _onTapOutside,
                child: widget.proxyBuilder(context),
              ),
            ),

            // -> popup
            widget.popupBuilder(
              context,
              value,
              widget.initialRect,
              _onTapOutside,
            ),
          ],
        );
      },
    );
  }
}
