part of "./event_service.dart";

@freezed
sealed class Event with _$Event {
  const factory Event.accountCreated({
    required Type sender,
    required AccountModel account,
  }) = EventAccountCreated;
}
