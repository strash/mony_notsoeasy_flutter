import "dart:math";

import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/components/time/time_popup.dart";

const _itemExtent = 35.0;
const _wheelHeight = 200.0;

class TimeComponent extends StatefulWidget {
  // final ValueNotifier<Duration> duration;
  // final Duration maxDuration;

  const TimeComponent({
    // required this.duration,
    // required this.maxDuration,
    super.key,
  });

  @override
  State<TimeComponent> createState() => _TimeComponentState();
}

class _TimeComponentState extends State<TimeComponent> {
  OverlayEntry? _entry;

  void onSelectHours(int number) {
    // duration.value = Duration(
    //   hours: number,
    //   minutes: wrapMinutes(from: duration.value),
    //   seconds: wrapSeconds(from: duration.value),
    // );
  }

  void onSelectMinutes(int number) {
    // duration.value = Duration(
    //   hours: wrapHours(from: duration.value),
    //   minutes: number,
    //   seconds: wrapSeconds(from: duration.value),
    // );
  }

  void onSelectSeconds(int number) {
    // duration.value = Duration(
    //   hours: wrapHours(from: duration.value),
    //   minutes: wrapMinutes(from: duration.value),
    //   seconds: number,
    // );
  }

  void _onTap() {
    _removeEntry();
    assert(_entry == null);

    final button = context.findRenderObject() as RenderBox?;
    final overlay =
        Navigator.of(context).overlay?.context.findRenderObject() as RenderBox?;
    if (button != null &&
        button.hasSize &&
        overlay != null &&
        overlay.hasSize) {
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

      final pos = position.toRect(overlay.paintBounds);
      _entry = OverlayEntry(
        builder: (context) {
          return TimePopupComponent(
            onTapOutside: _removeEntry,
            initialRect: pos,
          );
        },
      );
      if (_entry != null) {
        Overlay.of(context).insert(_entry!);
      }
    }
  }

  void _removeEntry() {
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
  }

  @override
  void dispose() {
    _removeEntry();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _onTap,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 12.r, cornerSmoothing: 1.0),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 8.h,
          ),
          child: Text(
            "10:25",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20.0,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
