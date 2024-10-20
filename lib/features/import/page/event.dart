sealed class ImportEvent {}

// step 1 (loading a file)
final class ImportEventInitial extends ImportEvent {}

final class ImportEventLoadingCsv extends ImportEvent {}

final class ImportEventErrorLoadingCsv extends ImportEvent {}

// step 2 (imported file summary)
final class ImportEventCsvLoaded extends ImportEvent {}

// step 3 (column mapping)
final class ImportEventMappingColumns extends ImportEvent {}

final class ImportEventValidatingMappedColumns extends ImportEvent {}

final class ImportEventErrorMappingColumns extends ImportEvent {}

final class ImportEventMappingColumnsValidated extends ImportEvent {}

// step 4 (map/create accounts)
final class ImportEventMapAccounts extends ImportEvent {}
