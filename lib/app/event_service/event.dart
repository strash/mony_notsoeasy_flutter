part of "./event_service.dart";

sealed class Event {
  final Type sender;
  const Event({required this.sender});
}

// -> account

final class EventAccountCreated extends Event {
  final AccountModel value;
  const EventAccountCreated({required super.sender, required this.value});
}

final class EventAccountUpdated extends Event {
  final AccountModel value;
  EventAccountUpdated({required super.sender, required this.value});
}

final class EventAccountDeleted extends Event {
  final AccountModel value;
  EventAccountDeleted({required super.sender, required this.value});
}

// -> category

final class EventCategoryUpdated extends Event {
  final CategoryModel value;
  const EventCategoryUpdated({required super.sender, required this.value});
}

// -> transaction

final class EventTransactionCreated extends Event {
  final TransactionModel value;
  const EventTransactionCreated({required super.sender, required this.value});
}

final class EventTransactionUpdated extends Event {
  final TransactionModel value;
  EventTransactionUpdated({required super.sender, required this.value});
}

final class EventTransactionDeleted extends Event {
  final TransactionModel value;
  EventTransactionDeleted({required super.sender, required this.value});
}
