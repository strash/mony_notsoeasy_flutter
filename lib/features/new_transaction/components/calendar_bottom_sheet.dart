import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/calendar/component.dart";

class NewTransactionCalendarBottomSheetComponent extends StatefulWidget {
  final double bottom;
  final CalendarController controller;

  const NewTransactionCalendarBottomSheetComponent({
    super.key,
    required this.bottom,
    required this.controller,
  });

  @override
  State<NewTransactionCalendarBottomSheetComponent> createState() =>
      _NewTransactionCalendarBottomSheetComponentState();
}

class _NewTransactionCalendarBottomSheetComponentState
    extends State<NewTransactionCalendarBottomSheetComponent> {
  late DateTime _visibleMonth;

  String _monthDescription = "";

  void _setDescription() {
    final now = DateTime.now();
    final formatter = _visibleMonth.year == now.year
        ? DateFormat("MMMM")
        : DateFormat("MMMM y");
    if (mounted) {
      setState(() => _monthDescription = formatter.format(_visibleMonth));
    }
  }

  void _onMonthChanged(DateTime newValue) {
    if (mounted) setState(() => _visibleMonth = newValue);
    _setDescription();
  }

  @override
  void initState() {
    super.initState();
    if (mounted) setState(() => _visibleMonth = widget.controller.visibleMonth);
    _setDescription();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final padding = EdgeInsets.symmetric(horizontal: 10.w);
    final itemWidth = (size.width - padding.horizontal) / DateTime.daysPerWeek;
    final isSameMonth =
        _visibleMonth.isSameDateAs(DateTime.now().firstDayOfMonth());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(15.w, .0, 15.w, 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // -> visible month
              AnimatedSwitcher(
                duration: Durations.medium1,
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: SizedBox(
                  key: Key(_monthDescription),
                  width: 180.w,
                  child: Text(
                    _monthDescription,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.golosText(
                      fontSize: 20.sp,
                      letterSpacing: -0.1,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),

              // -> button back to today
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: isSameMonth
                    ? null
                    : () => widget.controller.moveTo(DateTime.now()),
                child: AnimatedDefaultTextStyle(
                  duration: Durations.short4,
                  curve: Curves.easeInOut,
                  style: GoogleFonts.golosText(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: isSameMonth
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.colorScheme.secondary,
                  ),
                  child: const Text("Сегодня"),
                ),
              ),
            ],
          ),
        ),

        // -> calendar
        CalendarComponent(
          controller: widget.controller,
          padding: padding,
          itemHeight: itemWidth,
          childDelegate: const CalendarChildDelegate(),
          onMonthChanged: _onMonthChanged,
        ),

        // -> offset
        SizedBox(height: widget.bottom),
      ],
    );
  }
}
