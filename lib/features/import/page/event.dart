sealed class ImportEvent {}

// loading a file
final class ImportEventInitial extends ImportEvent {}

final class ImportEventLoadingCsv extends ImportEvent {}

final class ImportEventErrorLoadingCsv extends ImportEvent {}

// column mapping
final class ImportEventMappingColumns extends ImportEvent {}

final class ImportEventValidatingMappedColumns extends ImportEvent {}

final class ImportEventErrorMappingColumns extends ImportEvent {}

final class ImportEventMappingColumnsValidated extends ImportEvent {}

// map/create accounts
final class ImportEventMapAccounts extends ImportEvent {}

// map transaction type. optional
final class ImportEventMapTransactionType extends ImportEvent {}

// map categories
final class ImportEventMapCategories extends ImportEvent {}
