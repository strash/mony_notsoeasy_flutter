import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/calendar/component.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/components/time/component.dart";
import "package:mony_app/i18n/strings.g.dart";

class TransactionFormBottomSheetCalendarComponent extends StatefulWidget {
  final double bottom;
  final CalendarController dateController;
  final TimeController timeController;

  const TransactionFormBottomSheetCalendarComponent({
    super.key,
    required this.bottom,
    required this.dateController,
    required this.timeController,
  });

  @override
  State<TransactionFormBottomSheetCalendarComponent> createState() =>
      _TransactionFormBottomSheetCalendarComponentState();
}

class _TransactionFormBottomSheetCalendarComponentState
    extends State<TransactionFormBottomSheetCalendarComponent> {
  late DateTime _visibleMonth;

  String _monthDescription = "";

  void _setDescription(String locale) {
    if (mounted) {
      final now = DateTime.now();
      final formatter =
          _visibleMonth.year == now.year
              ? DateFormat("MMMM", locale)
              : DateFormat("MMMM y", locale);
      setState(() => _monthDescription = formatter.format(_visibleMonth));
    }
  }

  void _onMonthChanged(String locale, DateTime newValue) {
    if (mounted) {
      setState(() => _visibleMonth = newValue);
      _setDescription(locale);
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() => _visibleMonth = widget.dateController.visibleMonth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewSize = MediaQuery.sizeOf(context);
    const padding = EdgeInsets.symmetric(horizontal: 10.0);
    final itemWidth =
        (viewSize.width - padding.horizontal) / DateTime.daysPerWeek;

    final locale = Localizations.localeOf(context);
    final isSameMonth = _visibleMonth.isSameDateAs(
      DateTime.now().firstDayOfMonth(),
    );
    _setDescription(locale.languageCode);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, .0, 15.0, 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -> visible month
                  AnimatedSwitcher(
                    duration: Durations.medium1,
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: SizedBox(
                      key: Key(_monthDescription),
                      width: 180.0,
                      child: Text(
                        _monthDescription,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.golosText(
                          fontSize: 20.0,
                          letterSpacing: -0.1,
                          fontWeight: FontWeight.w500,
                          color: ColorScheme.of(context).onSurface,
                        ),
                      ),
                    ),
                  ),

                  // -> button back to today
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap:
                        isSameMonth
                            ? null
                            : () =>
                                widget.dateController.moveTo(DateTime.now()),
                    child: AnimatedDefaultTextStyle(
                      duration: Durations.short4,
                      curve: Curves.easeInOut,
                      style: GoogleFonts.golosText(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color:
                            isSameMonth
                                ? ColorScheme.of(context).onSurfaceVariant
                                : ColorScheme.of(context).secondary,
                      ),
                      child: Text(
                        context.t.features.transaction_form.calendar_today,
                      ),
                    ),
                  ),
                ],
              ),

              // -> time
              TimeComponent(controller: widget.timeController),
            ],
          ),
        ),

        // -> calendar
        CalendarComponent(
          controller: widget.dateController,
          padding: padding,
          itemHeight: itemWidth,
          childDelegate: const CalendarChildDelegate(),
          onMonthChanged: (value) {
            _onMonthChanged(locale.languageCode, value);
          },
        ),

        // -> offset
        SizedBox(height: widget.bottom + 20.0),
      ],
    );
  }
}
