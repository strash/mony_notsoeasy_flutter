import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/domain/services/csv_import_export.dart";
import "package:mony_app/features/features.dart";
import "package:provider/provider.dart";
import "package:rxdart/subjects.dart";

final class OnSelectFilePressedUseCase extends BaseUseCase<Future<void>> {
  final BehaviorSubject<ImportEvent> _subject;

  OnSelectFilePressedUseCase({required BehaviorSubject<ImportEvent> subject})
      : _subject = subject;

  @override
  Future<void> action(BuildContext context) async {
    try {
      _subject.add(ImportEventLoadingCsv());
      final service = context.read<ImportExportService>();
      final csv = await service.read();
      if (!context.mounted) return;
      if (csv != null) {
        _subject.add(ImportEventCsvLoaded(csv));
        final viewModel = ViewModel.of<StartAccountImportViewModel>(context);
        viewModel.forward();
      } else {
        _subject.add(ImportEventInitial());
      }
    } catch (e) {
      _subject.add(ImportEventErrorLoadingCsv());
    }
  }
}
