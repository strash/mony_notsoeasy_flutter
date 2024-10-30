part of "./event_service.dart";

sealed class Event {}

final class EventAccountCreated extends Event {
  final Type sender;
  final AccountModel account;

  EventAccountCreated({required this.sender, required this.account});
}
