import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:mony_app/common/extensions/extensions.dart";

part "./controller_event.dart";

/// A controller for managing the scrolling behavior of a calendar widget.
///
/// The `CalendarController` encapsulates a [ScrollController] to handle
/// scrolling. It has a method [moveTo] for moving to a specific date in the
/// calendar.
///
/// Properties:
/// - `scrollController`: The [ScrollController] used to control the scrolling
///   behavior of the calendar.
/// - `physics`: The scrolling physics applied to the calendar, intended
///   for internal use to enable page-like scrolling behavior.
///
/// Methods:
/// - [moveTo]: Method to move to a specific date with animation.
/// - [addEventListener]: Method to listen for a [CalendarEvent].
/// - [dispose]: It is a user responsibility to call this method.
final class CalendarController extends ChangeNotifier {
  DateTime? _value;

  DateTime? get value => _value;

  set value(DateTime? newValue) {
    _value = newValue;
    notifyListeners();
  }

  final ScrollController scrollController;

  final ScrollPhysics physics;

  final _subject = StreamController<CalendarEvent>.broadcast();

  DateTime visibleMonth;

  CalendarController(
    DateTime? value, {
    ScrollController? scrollController,
    ScrollPhysics? physics,
  })  : _value = value,
        visibleMonth = (value ?? DateTime.now()).firstDayOfMonth(),
        scrollController = scrollController ?? ScrollController(),
        physics = physics ??
            const PageScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            );

  void addEventListener(void Function(CalendarEvent event) listener) {
    _subject.stream.listen(listener);
  }

  Future<void> moveTo(
    DateTime date, {
    Duration duration = Durations.long1,
    Curve curve = Curves.easeInOutQuad,
  }) async {
    final diff =
        visibleMonth.firstDayOfMonth().monthOffset(date.firstDayOfMonth());
    ScrollDirection direction = ScrollDirection.idle;
    if (diff > 0) {
      direction = ScrollDirection.reverse;
    } else if (diff < 0) {
      direction = ScrollDirection.forward;
    }
    if (direction == ScrollDirection.idle) return;

    _subject.add(CalendarEventMoving(movingStep: diff, direction: direction));

    double offset = 0.0;
    if (direction == ScrollDirection.reverse) {
      offset = scrollController.position.extentInside * 2;
    }
    await scrollController.animateTo(offset, duration: duration, curve: curve);

    _subject.add(CalendarEventDoneMoving());
    visibleMonth = visibleMonth.firstDayOfMonth(diff);

    scrollController.jumpTo(scrollController.position.extentInside);
    _subject.add(CalendarEventStopMoving());
  }

  @override
  void dispose() {
    _subject.close();
    scrollController.dispose();
    super.dispose();
  }
}
