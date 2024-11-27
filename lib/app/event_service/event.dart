part of "./event_service.dart";

sealed class Event {
  const Event();
}

// -> account

final class EventAccountCreated extends Event {
  final AccountModel value;
  const EventAccountCreated(this.value);
}

final class EventAccountUpdated extends Event {
  final AccountModel value;
  EventAccountUpdated(this.value);
}

final class EventAccountDeleted extends Event {
  final AccountModel value;
  EventAccountDeleted(this.value);
}

// -> category

final class EventCategoryCreated extends Event {
  final CategoryModel value;
  EventCategoryCreated(this.value);
}

final class EventCategoryUpdated extends Event {
  final CategoryModel value;
  const EventCategoryUpdated(this.value);
}

final class EventCategoryDeleted extends Event {
  final CategoryModel value;
  EventCategoryDeleted(this.value);
}

// -> transaction

final class EventTransactionCreated extends Event {
  final TransactionModel value;
  const EventTransactionCreated(this.value);
}

final class EventTransactionUpdated extends Event {
  final TransactionModel value;
  EventTransactionUpdated(this.value);
}

final class EventTransactionDeleted extends Event {
  final TransactionModel value;
  EventTransactionDeleted(this.value);
}
