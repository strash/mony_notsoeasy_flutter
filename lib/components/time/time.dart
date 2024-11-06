import "package:flutter/material.dart";
import "package:mony_app/components/time/component.dart";
import "package:mony_app/components/time/time_proxy.dart";

class TimeComponent extends StatefulWidget {
  final TimeController controller;

  const TimeComponent({
    super.key,
    required this.controller,
  });

  @override
  State<TimeComponent> createState() => _TimeComponentState();
}

class _TimeComponentState extends State<TimeComponent> {
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
          return TimePopupComponent(
            controller: widget.controller,
            onTapOutside: _removeEntry,
            initialRect: position.toRect(overlay.paintBounds),
          );
        },
      );
    });
    if (_entry != null) {
      Overlay.of(context).insert(_entry!);
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
    return GestureDetector(
      onTap: _entry == null ? _onTap : null,
      child: Opacity(
        opacity: _entry == null ? 1.0 : .0,
        child: TimeProxyComponent(time: widget.controller.formattedValue),
      ),
    );
  }
}
