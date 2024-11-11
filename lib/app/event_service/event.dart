part of "./event_service.dart";

sealed class Event {
  final Type sender;

  const Event(this.sender);
}

final class EventAccountCreated<Type> extends Event {
  final AccountModel account;

  const EventAccountCreated({required this.account}) : super(Type);
}
