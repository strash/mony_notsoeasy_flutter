import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:mony_app/app.dart";
import "package:mony_app/components/components.dart";

typedef TPopupButtonBuilder =
    Widget Function(BuildContext context, bool isOpened, VoidCallback activate);

typedef TPopupButtonProxyBuilder =
    Widget Function(
      BuildContext context,
      double animation,
      AnimationStatus status,
      Rect proxyRect,
      VoidCallback dismiss,
    );

typedef TPopupBuilder = TPopupButtonProxyBuilder;

class PopupButtonComponent extends StatefulWidget {
  final TPopupButtonBuilder builder;
  final TPopupButtonProxyBuilder proxyBuilder;
  final TPopupBuilder popupBuilder;
  final bool showBackground;
  final bool blurBackground;

  const PopupButtonComponent({
    super.key,
    required this.builder,
    required this.proxyBuilder,
    required this.popupBuilder,
    this.showBackground = true,
    this.blurBackground = true,
  });

  @override
  State<PopupButtonComponent> createState() => _PopupButtonComponentState();
}

class _PopupButtonComponentState extends State<PopupButtonComponent> {
  OverlayEntry? _entry;

  void _onTap() {
    _removeEntry();
    assert(_entry == null);

    final button = context.findRenderObject() as RenderBox?;
    final overlay =
        kAppNavigatorKey.currentState?.overlay ??
        Overlay.of(context, rootOverlay: true);
    final overlayRb = overlay.context.findRenderObject() as RenderBox?;
    if (button == null ||
        !button.hasSize ||
        overlayRb == null ||
        !overlayRb.hasSize) {
      return;
    }

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlayRb),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlayRb,
        ),
      ),
      Offset.zero & overlayRb.size,
    );

    if (!mounted) return;

    final captured = InheritedTheme.capture(from: context, to: overlay.context);
    setState(() {
      _entry = OverlayEntry(
        builder: (context) {
          return captured.wrap(
            PopupOverlayComponent(
              onTapOutside: _removeEntry,
              initialRect: position.toRect(overlayRb.paintBounds),
              proxyBuilder: widget.proxyBuilder,
              popupBuilder: widget.popupBuilder,
              showBackground: widget.showBackground,
              blurBackground: widget.blurBackground,
            ),
          );
        },
      );
    });
    if (_entry != null) {
      overlay.insert(_entry!);
    }
  }

  void _removeEntry() {
    if (!mounted) return;
    setState(() {
      _entry?.remove();
      _entry?.dispose();
      _entry = null;
    });
  }

  @override
  void dispose() {
    // NOTE: don't put this in setState
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _entry != null, _onTap);
  }
}
