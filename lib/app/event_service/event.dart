part of "./event_service.dart";

@freezed
class Event with _$Event {
  const factory Event.accountCreated({
    required Type sender,
    required AccountModel account,
  }) = EventAccountCreated;
}
