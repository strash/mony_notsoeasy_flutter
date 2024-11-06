import "package:flutter/material.dart";
import "package:intl/intl.dart";

final class TimeController extends ChangeNotifier {
  DateTime _value;

  DateTime get value => _value;

  set value(DateTime newValue) {
    _value = newValue;
    notifyListeners();
  }

  TimeController(DateTime value) : _value = value;

  String get formattedValue {
    final formatter = DateFormat("HH:mm");
    return formatter.format(value);
  }

  void setHours(int newValue) {
    value = DateTime(
      _value.year,
      _value.month,
      _value.day,
      newValue,
      _value.minute,
      _value.second,
    );
  }

  void setMinutes(int newValue) {
    value = DateTime(
      _value.year,
      _value.month,
      _value.day,
      _value.hour,
      newValue,
      _value.second,
    );
  }
}
