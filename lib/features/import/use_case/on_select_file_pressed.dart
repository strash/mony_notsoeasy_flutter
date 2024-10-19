import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/services/csv_import_export.dart";
import "package:mony_app/features/features.dart";
import "package:provider/provider.dart";

final class OnSelectFilePressed extends UseCase<void, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final viewModel = context.viewModel<ImportViewModel>();
    final subject = viewModel.subject;
    try {
      subject.add(ImportEventLoadingCsv());
      final service = context.read<ImportExportService>();
      final csv = await service.read();
      if (!context.mounted) return;
      if (csv != null) {
        viewModel.setProtectedState(() {
          viewModel.csv = csv;
          viewModel.progress++;
        });
        subject.add(ImportEventCsvLoaded());
      } else {
        subject.add(ImportEventInitial());
      }
    } catch (e) {
      subject.add(ImportEventErrorLoadingCsv());
    }
  }
}
