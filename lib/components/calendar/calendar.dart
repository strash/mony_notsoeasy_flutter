import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/calendar/component.dart";

part "./month.dart";

/// The CalendarComponent by itself doesn't handle dates.
/// It is the responsibility of the `childDelegate` to process each day.
///
/// Parameters:
/// - `activeDate` is used to determine which month will be displayed on the
///   screen. If `activeDate` is omitted, `DateTime.now()` will be used.
/// - `itemHeight` is required to determine the overall height of the component.
/// - `padding` is used for each month block. By default, it is set to
///   [EdgeInsets.zero].
/// - `childDelegate` is responsible for rendering each day. You can use
///   predefined delegate [CalendarChildDelegate]
/// - `onMonthChanged` will be called each time the month changes.
class CalendarComponent extends StatefulWidget {
  final CalendarController? controller;
  final double itemHeight;
  final EdgeInsets padding;
  final ICalendarChildDelegate childDelegate;
  final void Function(DateTime visibleMonth)? onMonthChanged;

  const CalendarComponent({
    super.key,
    this.controller,
    required this.itemHeight,
    this.padding = EdgeInsets.zero,
    required this.childDelegate,
    this.onMonthChanged,
  });

  @override
  State<CalendarComponent> createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {
  late final CalendarController _controller;
  bool _moving = false;

  late List<_Month> _list = _generate();
  final int _lines = 6;

  List<_Month> _generate() {
    final start = _controller.visibleMonth.offsetMonth(-1);
    return List<_Month>.generate(3, (index) {
      return _Month(
        controller: _controller,
        date: start.firstDayOfMonth(index),
        height: widget.itemHeight,
        padding: widget.padding,
        lineCount: _lines,
        childDelegate: widget.childDelegate,
      );
    });
  }

  void _handlePosition() {
    if (_moving || !_controller.scrollController.isReady) return;

    final direction = _controller.scrollController.position.userScrollDirection;
    final pos = _controller.scrollController.position.pixels;
    final minPos = _controller.scrollController.position.minScrollExtent;
    final maxPos = _controller.scrollController.position.maxScrollExtent;
    final atEdge = pos <= minPos || pos >= maxPos;
    final date = _controller.visibleMonth;
    // notify for a month change (cosmetics)
    if (widget.onMonthChanged != null) {
      final halfScreen = _controller.scrollController.position.extentInside / 2;
      int monthOffset = 0;
      // scroll from right to left and offset is half of the screen
      if (direction == ScrollDirection.reverse) {
        if (pos >= maxPos - halfScreen) monthOffset += 1;
      }
      // scroll from left to right and offset is half of the screen
      if (direction == ScrollDirection.forward) {
        if (pos <= halfScreen) monthOffset -= 1;
      }
      widget.onMonthChanged!.call(date.firstDayOfMonth(monthOffset));
    }
    // at edge (real shit)
    if (atEdge) {
      _controller.scrollController
          .jumpTo(_controller.scrollController.position.extentInside);
      final monthOffset = switch (direction) {
        ScrollDirection.idle => 0,
        ScrollDirection.forward => 0 - 1,
        ScrollDirection.reverse => 0 + 1,
      };
      _controller.visibleMonth = date.firstDayOfMonth(monthOffset);
      if (!mounted) return;
      setState(() => _list = _generate());
      if (widget.onMonthChanged != null) {
        widget.onMonthChanged?.call(_controller.visibleMonth);
      }
    }
  }

  void _controllerListener(CalendarEvent event) {
    switch (event) {
      case CalendarEventMoving(movingStep: final diff, direction: final dir):
        _moving = true;
        final start = _controller.visibleMonth.firstDayOfMonth(diff);
        final month = _Month(
          controller: _controller,
          date: start,
          height: widget.itemHeight,
          padding: widget.padding,
          lineCount: _lines,
          childDelegate: widget.childDelegate,
        );
        if (!mounted) return;
        setState(() {
          if (dir == ScrollDirection.reverse) {
            _list = List<_Month>.from(_list)
              ..removeAt(_list.length - 1)
              ..add(month);
          } else {
            _list = List<_Month>.from(_list)
              ..removeAt(0)
              ..insert(0, month);
          }
        });
      case CalendarEventDoneMoving():
        if (!mounted) return;
        setState(() => _list = _generate());
      case CalendarEventStopMoving():
        if (widget.onMonthChanged != null) {
          widget.onMonthChanged?.call(_controller.visibleMonth);
        }
        _moving = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? CalendarController(null);
    _controller.scrollController.addListener(_handlePosition);
    _controller.addEventListener(_controllerListener);

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (!_controller.scrollController.isReady) return;
      _controller.scrollController.jumpTo(MediaQuery.sizeOf(context).width);
    });
  }

  @override
  void dispose() {
    _controller.scrollController.removeListener(_handlePosition);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = MaterialLocalizations.of(context);
    final theme = Theme.of(context);
    final weekHeight = 26.h;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
            maxHeight: widget.itemHeight * _lines +
                widget.padding.vertical +
                weekHeight,
          ),
          child: Column(
            children: [
              // -> week days
              SizedBox(
                height: weekHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.padding.left,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: DateTimeEx.weekDayList(loc).map<Widget>((e) {
                      return Text(
                        e,
                        style: GoogleFonts.golosText(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    }).toList(growable: false),
                  ),
                ),
              ),

              // -> months
              Flexible(
                child: ListView(
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: _controller.physics,
                  controller: _controller.scrollController,
                  itemExtent: constraints.maxWidth,
                  children: _list,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
