import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/navbar/page/view.dart";

typedef TContextMenuProxyBuilder =
    Widget Function(
      BuildContext context,
      double animation,
      VoidCallback dismiss,
    );

typedef TContextMenuPopupBuilder = TContextMenuProxyBuilder;

class ContextMenuComponent extends StatefulWidget {
  final Offset offset;
  final bool showBackground;
  final bool blurBackground;
  final bool shiftIntoBounds;
  final TPopupButtonBuilder buttonBuilder;
  final TContextMenuProxyBuilder buttonProxyBuilder;
  final TContextMenuPopupBuilder popupBuilder;

  const ContextMenuComponent({
    super.key,
    this.offset = const Offset(8.0, 8.0),
    this.showBackground = true,
    this.blurBackground = true,
    this.shiftIntoBounds = false,
    required this.buttonBuilder,
    required this.buttonProxyBuilder,
    required this.popupBuilder,
  });

  @override
  State<ContextMenuComponent> createState() => _ContextMenuComponentState();
}

class _ContextMenuComponentState extends State<ContextMenuComponent> {
  late final _sizeController =
      SizeNotifierController()..addListener(_sizeListener);

  late final _yUpperBound =
      MediaQuery.viewPaddingOf(context).top + AppBarComponent.height + 20.0;
  late final _yLowerBound =
      MediaQuery.of(context).viewPadding.bottom +
      NavBarView.kBottomMargin * 2.0 +
      NavBarView.kTabHeight +
      10.0;

  double get _width => MediaQuery.sizeOf(context).width * 0.72;

  Rect _proxyRect = Rect.zero;
  // NOTE: initial height must be very big
  late Rect _menuRect = Rect.fromLTWH(.0, .0, _width, 1_000_000.0);
  double _yOffset = .0;
  Alignment _alignment = Alignment.topRight;

  void _sizeListener() {
    final size = _sizeController.size;
    final viewSize = MediaQuery.sizeOf(context);
    final bounds =
        Offset(.0, _yUpperBound) &
        Size(viewSize.width, viewSize.height - _yUpperBound - _yLowerBound);

    final isPopupOnRight =
        (_proxyRect.left + size.width).toInt() > viewSize.width.toInt();
    final isPopupOnTop =
        (_proxyRect.top + _proxyRect.height + widget.offset.dy + size.height)
            .toInt() >
        (viewSize.height - _yLowerBound).toInt();

    Rect rect = Offset(_proxyRect.left, _proxyRect.top) & size;

    if (isPopupOnRight) {
      rect = rect.shift(-Offset(size.width - _proxyRect.width, .0));
      // offset from the right edge of the screen
      if (rect.right.toInt() == viewSize.width.toInt()) {
        rect = rect.shift(-Offset.zero.addDx(widget.offset));
      }
    } else {
      // offset from the left edge of the screen
      if (rect.left.toInt() == 0) {
        rect = rect.shift(Offset.zero.addDx(widget.offset));
      }
    }
    if (!isPopupOnTop) {
      rect = rect.shift(Offset(.0, _proxyRect.height + widget.offset.dy));
      if (_proxyRect.top < bounds.top) {
        _yOffset = bounds.top - _proxyRect.top;
      }
    } else {
      rect = rect.shift(-Offset(.0, size.height + widget.offset.dy));
      if (_proxyRect.bottom > bounds.bottom) {
        _yOffset = _yOffset = bounds.bottom - _proxyRect.bottom;
      }
    }

    if (!widget.shiftIntoBounds) _yOffset = .0;

    setState(() {
      _menuRect = rect;
      if (isPopupOnRight && isPopupOnTop) {
        _alignment = Alignment.bottomRight;
      } else if (!isPopupOnRight && isPopupOnTop) {
        _alignment = Alignment.bottomLeft;
      } else if (isPopupOnRight && !isPopupOnTop) {
        _alignment = Alignment.topRight;
      } else {
        _alignment = Alignment.topLeft;
      }
    });
  }

  @override
  void dispose() {
    _sizeController.isDisposed = true;
    _sizeController.removeListener(_sizeListener);
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopupButtonComponent(
      showBackground: widget.showBackground,
      blurBackground: widget.blurBackground,
      builder: (context, isOpened, activate) {
        return widget.buttonBuilder(context, isOpened, activate);
      },
      proxyBuilder: (context, anim, proxyRect, dismiss) {
        final t = Curves.easeInOut.transform(anim);
        final offset = Offset(.0, t.remap(.0, 1.0, .0, _yOffset));

        return Positioned.fromRect(
          rect: proxyRect.shift(offset),
          child: widget.buttonProxyBuilder(context, anim, dismiss),
        );
      },
      popupBuilder: (context, anim, proxyRect, dismiss) {
        _proxyRect = proxyRect;
        final t = Curves.easeInOutSine.transform(anim);
        final offset = Offset(.0, t.remap(.0, 1.0, .0, _yOffset));

        return Positioned.fromRect(
          rect: _menuRect.shift(offset),
          child: Center(
            child: SizeNotifierComponent(
              width: _width,
              controller: _sizeController,
              child: Transform.scale(
                scale: t.remap(.0, 1.0, .4, 1.0),
                alignment: _alignment,
                child: Opacity(
                  opacity: t,
                  child: PopupContainerComoponent(
                    builder: (context) {
                      return widget.popupBuilder(context, anim, dismiss);
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
