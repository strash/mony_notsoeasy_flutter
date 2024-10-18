sealed class ImportEvent {}

// step 1
final class ImportEventInitial extends ImportEvent {}

final class ImportEventLoadingCsv extends ImportEvent {}

final class ImportEventErrorLoadingCsv extends ImportEvent {}

// step 2
final class ImportEventCsvLoaded extends ImportEvent {}

// step 3
final class ImportEventMapAccount extends ImportEvent {}

final class ImportEventMapAmount extends ImportEvent {}

final class ImportEventMapExpenseType extends ImportEvent {}

final class ImportEventMapDate extends ImportEvent {}

final class ImportEventMapCategory extends ImportEvent {}

final class ImportEventMapTag extends ImportEvent {}

final class ImportEventMapNote extends ImportEvent {}
