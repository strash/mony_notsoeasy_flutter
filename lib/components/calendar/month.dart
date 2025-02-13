part of "./calendar.dart";

class _Month extends StatelessWidget {
  final CalendarController controller;
  final DateTime date;
  final double height;
  final EdgeInsets padding;
  final int lineCount;
  final ICalendarChildDelegate childDelegate;

  const _Month({
    required this.controller,
    required this.date,
    required this.height,
    required this.padding,
    required this.lineCount,
    required this.childDelegate,
  });

  @override
  Widget build(BuildContext context) {
    final loc = MaterialLocalizations.of(context);
    final daysInMonth = date.daysInMonth;
    final weekDay = date.weekDayIndex(loc);
    int index = 0;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(lineCount, (cIdx) {
          return Row(
            children: List<Widget>.generate(7, (rIdx) {
              final isEmpty = index < weekDay || index >= weekDay + daysInMonth;
              final current = date.add(Duration(days: index - weekDay));

              final child = Expanded(
                child: Center(
                  child: SizedBox(
                    height: height,
                    child:
                        !isEmpty
                            ? childDelegate.build(context, controller, current)
                            : const SizedBox(),
                  ),
                ),
              );
              index++;
              return child;
            }),
          );
        }),
      ),
    );
  }
}
