import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:mony_app/components/components.dart";

typedef TPopupButtonBuilder = Widget Function(
  BuildContext context,
  bool isOpened,
  VoidCallback activate,
);

typedef TPopupBuilder = TPopupButtonProxyBuilder;

typedef TPopupButtonProxyBuilder = Widget Function(
  BuildContext context,
  double animation,
  Rect proxyRect,
  VoidCallback dismiss,
);

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
        Navigator.of(context).overlay?.context.findRenderObject() as RenderBox?;
    if (button == null ||
        !button.hasSize ||
        overlay == null ||
        !overlay.hasSize) {
      return;
    }

    const offset = Offset.zero;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + offset,
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    if (!mounted) return;
    setState(() {
      _entry = OverlayEntry(
        builder: (context) {
          return PopupOverlayComponent(
            onTapOutside: _removeEntry,
            initialRect: position.toRect(overlay.paintBounds),
            proxyBuilder: widget.proxyBuilder,
            popupBuilder: widget.popupBuilder,
            showBackground: widget.showBackground,
            blurBackground: widget.blurBackground,
          );
        },
      );
    });
    if (_entry != null) {
      Overlay.of(context, rootOverlay: true).insert(_entry!);
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
