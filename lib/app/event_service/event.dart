part of "./event_service.dart";

sealed class Event {
  final Type sender;

  const Event({required this.sender});
}

final class EventAccountCreated extends Event {
  final AccountModel account;

  const EventAccountCreated({
    required super.sender,
    required this.account,
  });
}

final class EventTransactionCreated extends Event {
  final TransactionModel transaction;

  const EventTransactionCreated({
    required super.sender,
    required this.transaction,
  });
}

final class EventTransactionUpdated extends Event {
  final TransactionModel transaction;

  EventTransactionUpdated({
    required super.sender,
    required this.transaction,
  });
}
