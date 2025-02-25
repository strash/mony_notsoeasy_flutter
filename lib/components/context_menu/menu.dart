import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";

class ContextMenuComponent extends StatefulWidget {
  final double offset;
  final bool showBackground;
  final bool blurBackground;
  final bool isActive;
  final WidgetBuilder buttonBuilder;
  final Widget Function(BuildContext context, VoidCallback dismiss)
  itemsBuilder;

  const ContextMenuComponent({
    super.key,
    this.offset = 8.0,
    this.showBackground = true,
    this.blurBackground = true,
    this.isActive = true,
    required this.buttonBuilder,
    required this.itemsBuilder,
  });

  @override
  State<ContextMenuComponent> createState() => _ContextMenuComponentState();
}

class _ContextMenuComponentState extends State<ContextMenuComponent> {
  final _sizeNotifier = ValueNotifier<Size>(Size.zero);

  Rect _proxyRect = Rect.zero;
  // NOTE: initial height must be very big
  late Rect _menuRect = Rect.fromLTWH(.0, .0, _width, 1_000_000.0);
  Alignment _alignment = Alignment.topRight;

  double get _width => MediaQuery.sizeOf(context).width * 0.72;

  void _sizeListener() {
    final size = _sizeNotifier.value;
    final viewSize = MediaQuery.sizeOf(context);
    final init = _proxyRect;
    final isOnRight = init.left + size.width > viewSize.width;
    final isOnTop =
        init.top + init.height + widget.offset + size.height > viewSize.height;
    Rect rect = Rect.fromLTWH(init.left, init.top, size.width, size.height);
    if (isOnRight) {
      rect = rect.shift(-Offset(size.width - init.width, .0));
      // offset from the right edge of the screen
      if (rect.right.toInt() == viewSize.width.toInt()) {
        rect = rect.shift(-Offset(widget.offset, .0));
      }
    } else {
      // offset from the left edge of the screen
      if (rect.left.toInt() == 0) rect = rect.shift(Offset(widget.offset, .0));
    }
    if (!isOnTop) {
      rect = rect.shift(Offset(.0, init.height + widget.offset));
    } else {
      rect = rect.shift(-Offset(.0, size.height + widget.offset));
    }
    setState(() {
      _menuRect = rect;
      if (isOnRight && isOnTop) {
        _alignment = Alignment.bottomRight;
      } else if (!isOnRight && isOnTop) {
        _alignment = Alignment.bottomLeft;
      } else if (isOnRight && !isOnTop) {
        _alignment = Alignment.topRight;
      } else {
        _alignment = Alignment.topLeft;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _sizeNotifier.addListener(_sizeListener);
  }

  @override
  void dispose() {
    _sizeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopupButtonComponent(
      showBackground: widget.showBackground,
      blurBackground: widget.blurBackground,
      builder: (context, isOpened, activate) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isOpened || !widget.isActive ? null : activate,
          child: AnimatedOpacity(
            duration: Durations.short4,
            opacity: widget.isActive ? 1.0 : .3,
            child: Opacity(
              opacity: isOpened ? .0 : 1.0,
              child: widget.buttonBuilder(context),
            ),
          ),
        );
      },
      proxyBuilder: (context, anim, proxyRect, dismiss) {
        return Positioned.fromRect(
          rect: proxyRect,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: dismiss,
            child: widget.buttonBuilder(context),
          ),
        );
      },
      popupBuilder: (context, anim, proxyRect, dismiss) {
        _proxyRect = proxyRect;

        return Positioned.fromRect(
          rect: _menuRect,
          child: Center(
            child: _Size(
              width: _width,
              sizeNotifier: _sizeNotifier,
              child: Transform.scale(
                scale: anim.remap(.0, 1.0, .4, 1.0),
                alignment: _alignment,
                child: Opacity(
                  opacity: anim,
                  child: PopupContainerComoponent(
                    builder: (context) {
                      return widget.itemsBuilder(context, dismiss);
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Size extends StatelessWidget {
  final ValueNotifier<Size> sizeNotifier;
  final double width;
  final Widget child;

  const _Size({
    required this.sizeNotifier,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final a = context.findRenderObject() as RenderBox?;
      if (a != null) sizeNotifier.value = a.size;
    });

    return SizedBox(width: width, child: child);
  }
}
