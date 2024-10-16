import "package:freezed_annotation/freezed_annotation.dart";
import "package:mony_app/domain/domain.dart";

part "model.freezed.dart";

@freezed
class ImportModelEvent with _$ImportModelEvent {
  // step 1
  const factory ImportModelEvent.initial() = ImportModelEventInitial;
  const factory ImportModelEvent.loadingCsv() = ImportModelEventLoadingCsv;
  const factory ImportModelEvent.csvLoaded({
    required ImportedCsvValueObject csv,
  }) = ImportModelEventCsvloaded;
  const factory ImportModelEvent.errorLoadingCsv() =
      ImportModelEventErrorLoadingCsv;
}
