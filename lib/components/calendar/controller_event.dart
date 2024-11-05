part of "./controller.dart";

sealed class CalendarEvent {}

final class CalendarEventMoving extends CalendarEvent {
  final int movingStep;
  final ScrollDirection direction;

  CalendarEventMoving({required this.movingStep, required this.direction});
}

final class CalendarEventDoneMoving extends CalendarEvent {}

final class CalendarEventStopMoving extends CalendarEvent {}
