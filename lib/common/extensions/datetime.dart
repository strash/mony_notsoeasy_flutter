import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";

final _monthLength = List<int>.unmodifiable([
  31,
  28,
  31,
  30,
  31,
  30,
  31,
  31,
  30,
  31,
  30,
  31,
]);

extension DateTimeEx on DateTime {
  /// Returns a localized list of weekday names starting from the correct
  /// first day of the week.
  ///
  /// The list is localized based on the provided [MaterialLocalizations].
  ///
  /// Example:
  /// - S, M, T, W, T, F, S - in English with the week starting from Saturday.
  /// - пн, вт, ср, чт, пт, сб, вс - in Russian with the week starting from
  ///   Monday.
  static List<String> weekDayList(MaterialLocalizations localizations) {
    final int startOfTheWeek = localizations.firstDayOfWeekIndex;
    return localizations.narrowWeekdays
        .skip(startOfTheWeek)
        .toList(growable: true)
      ..addAll(localizations.narrowWeekdays.take(startOfTheWeek));
  }

  /// Returns the zero-based index of the weekday for the date.
  ///
  /// The index is zero-based, meaning that the first day of the week is
  /// represented as 0. Use [DateTimeEx.weekDayList] to find the name of the
  /// weekday corresponding to this index.
  ///
  /// Example:
  /// ```dart
  /// final loc = MaterialLocalizations.of(context);
  /// final index = DateTime.now().weekDayIndex(loc);
  /// print(DateTimeEx.weekDayList(loc)[index]);
  /// // will print 'M' if it's Monday and the language is English
  /// ```
  int weekDayIndex(MaterialLocalizations localizations) {
    const daysPerWeek = DateTime.daysPerWeek;
    // to zero based week (DateTime.weekday starts from 1 and end at 7)
    final weekday = this.weekday.wrapi(0, daysPerWeek);
    // substract offset and wrap again
    return (weekday - localizations.firstDayOfWeekIndex).wrapi(0, daysPerWeek);
  }

  /// Returns a [DateTime] object representing the start of the current day.
  ///
  /// This getter constructs a new [DateTime] instance with the year, month,
  /// and day of the current date, setting the time to midnight (00:00:00).
  /// This is useful for operations that require a reference to the beginning
  /// of the day, such as comparisons or date calculations.
  ///
  /// Returns:
  /// - A [DateTime] object that represents the start of the current day.
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Compares the current date with another [DateTime] object to determine
  /// if they represent the same calendar day.
  ///
  /// This method checks if the day, month, and year of the current date
  /// are equal to those of the provided [other] date. It returns `true`
  /// if both dates are the same day, and `false` otherwise.
  ///
  /// Parameters:
  /// - [other]: The [DateTime] object to compare against.
  ///
  /// Returns:
  /// - `true` if the current date is the same day as [other],
  /// - `false` if they are different days.
  bool isSameDateAs(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }

  bool isSameMonthAs(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Returns a formatted date string.
  ///
  /// The `dateFormatter` and `timeFormatter` can be obtained from
  /// [MaterialLocalizations]. If `timeFormatter` is provided, it will be used
  /// to format the time.
  ///
  /// Parameters:
  /// - `dateFormatter`: A function that formats the date.
  /// - `timeFormatter`: An optional function that formats the time. If
  ///   provided, it will be used to include the time in the output.
  ///
  /// Returns:
  /// - A formatted date string, optionally including the time if
  ///   `timeFormatter` is provided.
  String description({
    required String Function(DateTime date) dateFormatter,
    String Function(TimeOfDay time, {bool alwaysUse24HourFormat})?
    timeFormatter,
  }) {
    final year = this.year;
    final dateFormatted = dateFormatter(this);
    final dateResult =
        year != DateTime.now().year && !dateFormatted.contains(year.toString())
            ? "$dateFormatted $year"
            : dateFormatted;
    if (timeFormatter != null) {
      final timeOfDay = TimeOfDay.fromDateTime(this);
      final time = timeFormatter(timeOfDay);
      return "$dateResult $time";
    }
    return dateResult;
  }

  /// Returns `true` if the year containing the date is a leap year; otherwise,
  /// returns `false`.
  ///
  /// A leap year has 366 days instead of the usual 365 days.
  ///
  /// Returns:
  /// - `true` if the year is a leap year, `false` otherwise.
  bool get isLeapYear {
    return (year % 400 == 0) || (year % 4 == 0 && year % 100 != 0);
  }

  /// Returns the number of days in the month that contains the date.
  ///
  /// This method takes into account whether the year is a leap year when
  /// calculating the number of days in February. For example, February has
  /// 29 days in a leap year and 28 days in a non-leap year.
  ///
  /// Returns:
  /// - An integer representing the number of days in the month.
  int get daysInMonth {
    if (isLeapYear && month == DateTime.february) {
      return _monthLength[month - 1] + 1;
    }
    return _monthLength[month - 1];
  }

  /// Returns a new date representing the first day of the month, shifted by
  /// the specified `offset`.
  ///
  /// The `offset` can be any integer and is optional:
  /// - `0` (default) represents the current month,
  /// - `-1` represents the previous month,
  /// - `1` represents the next month.
  ///
  /// Example:
  /// ```dart
  /// final someDate = DateTime(2000, DateTime.march, 10);
  /// // will print '2000-03-01 00:00:00.000'
  /// print(someDate.firstDayOfMonth()); // Default offset is 0
  /// print(someDate.firstDayOfMonth(1)); // Next month
  /// ```
  DateTime firstDayOfMonth([int offset = 0]) {
    if (offset == 0) return DateTime(year, month);
    final offsettedMonth = shiftMonth(offset);
    return DateTime(offsettedMonth.year, offsettedMonth.month);
  }

  /// Returns the first day of the week for the given [DateTime] instance
  /// based on the provided [localizations].
  DateTime firstDayOfWeek(MaterialLocalizations localizations) {
    final index = weekDayIndex(localizations);
    return subtract(Duration(days: index)).startOfDay;
  }

  /// Returns a new date with the month shifted by the specified `offset`.
  ///
  /// The `offset` can be any integer:
  /// - ` 0` represents the current month,
  /// - `-1` represents the previous month,
  /// - ` 1` represents the next month.
  ///
  /// Example:
  /// ```dart
  /// final someDate = DateTime(2000, DateTime.march, 10);
  /// // will print '2000-04-10 00:00:00.000'
  /// print(someDate.offsetMonth(1));
  /// ```
  DateTime shiftMonth(int offset) {
    final mo = month + offset;
    final nextMonth = mo.wrapi(DateTime.january, DateTime.december + 1);
    final yearOffset = ((mo - 1) / DateTime.monthsPerYear).floor();
    return DateTime(year + yearOffset, nextMonth, day);
  }

  /// Returns the difference in months between this date and another [DateTime].
  ///
  /// The method calculates the total number of months between the two dates,
  /// taking into account the year and month differences. If the day of the
  /// other date is earlier than the day of this date, the result is decremented
  /// by one to reflect that a full month has not yet passed.
  ///
  /// Example:
  /// ```dart
  /// final date1 = DateTime(2023, 1, 15);
  /// final date2 = DateTime(2024, 3, 10);
  /// final monthsDifference = date1.monthOffset(date2);
  /// print(monthsDifference); // 14
  /// ```
  int monthOffset(DateTime other) {
    final int yearDiff = other.year - year;
    final int monthDiff = other.month - month;
    int totalMonthDiff = yearDiff * 12 + monthDiff;
    if (other.day < day) totalMonthDiff--;
    return totalMonthDiff;
  }

  /// Returns a list of [DateTime] objects representing the first day of
  /// each month in the year of the current [DateTime] instance.
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(2025, DateTime.september);
  /// print(dateTime.monthsOfYear());
  /// // [2025-01-01 00:00:00.000, ... 2025-12-01 00:00:00.000]
  /// ```
  List<DateTime> monthsOfYear() {
    return List.generate(DateTime.monthsPerYear, (index) {
      final month = (index + 1).wrapi(DateTime.january, DateTime.december + 1);
      return DateTime(year, month);
    }).toList(growable: false);
  }

  /// Returns a list of [DateTime] objects representing each day of the
  /// month for the current [DateTime] instance.
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(2025, DateTime.january, 25);
  /// print(dateTime.daysOfMonth());
  /// // [2025-01-01 00:00:00.000, ... 2025-01-31 00:00:00.000]
  /// ```
  List<DateTime> daysOfMonth() {
    return List.generate(daysInMonth, (index) {
      return DateTime(year, month, index + 1);
    });
  }

  /// Returns a list of [DateTime] objects representing each day of the
  /// week for the current [DateTime] instance, based on the provided
  /// [localizations].
  ///
  /// Example:
  /// ```dart
  /// final loc = MaterialLocalizations.of(context);
  /// final dateTime = DateTime(2025, DateTime.january, 25);
  /// print(dateTime.daysOfWeek(loc));
  /// // [2025-01-19 00:00:00.000, ... 2025-01-25 00:00:00.000]
  /// ```
  List<DateTime> daysOfWeek(MaterialLocalizations localizations) {
    final startOfWeek = firstDayOfWeek(localizations).startOfDay;
    return List.generate(DateTime.daysPerWeek, (index) {
      return startOfWeek.add(Duration(days: index));
    });
  }
}
