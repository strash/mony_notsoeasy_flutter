import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/services/csv_import_export.dart";
import "package:mony_app/features/features.dart";
import "package:provider/provider.dart";
import "package:rxdart/subjects.dart";

final class OnSelectFilePressedUseCase extends BaseUseCase<Future<void>> {
  final BehaviorSubject<ImportModelEvent> _subject;
  final VoidCallback _forward;

  OnSelectFilePressedUseCase({
    required BehaviorSubject<ImportModelEvent> subject,
    required void Function() forward,
  })  : _subject = subject,
        _forward = forward;

  @override
  Future<void> action(BuildContext context) async {
    try {
      _subject.add(const ImportModelEvent.loadingCsv());
      final service = context.read<ImportExportService>();
      final csv = await service.read();
      if (!context.mounted) return;
      if (csv != null) {
        _subject.add(ImportModelEvent.csvLoaded(csv: csv));
        _forward();
      } else {
        _subject.add(const ImportModelEvent.initial());
      }
    } catch (e) {
      _subject.add(const ImportModelEvent.errorLoadingCsv());
    }
  }
}
