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

// -> tag

final class EventTagCreated extends Event {
  final TagModel value;
  const EventTagCreated(this.value);
}

final class EventTagUpdated extends Event {
  final TagModel value;
  const EventTagUpdated(this.value);
}

final class EventTagDeleted extends Event {
  final TagModel value;
  const EventTagDeleted(this.value);
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

// -> settings

final class EventSettingsThemeModeChanged extends Event {
  final ThemeMode value;
  EventSettingsThemeModeChanged(this.value);
}

final class EventSettingsColorsVisibilityChanged extends Event {
  final bool value;
  EventSettingsColorsVisibilityChanged(this.value);
}

final class EventSettingsCentsVisibilityChanged extends Event {
  final bool value;
  EventSettingsCentsVisibilityChanged(this.value);
}
