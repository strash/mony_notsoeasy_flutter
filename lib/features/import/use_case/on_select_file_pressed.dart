import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/services/filesystem/import_export.dart";
import "package:mony_app/features/features.dart";

final class OnSelectFilePressed extends UseCase<void, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final viewModel = context.viewModel<ImportViewModel>();
    final subject = viewModel.subject;
    try {
      subject.add(ImportEventLoadingCsv());
      final service = context.service<DomainImportExportService>();
      final csv = await service.importCSV();
      if (!context.mounted) return;
      final step = ImportModelCsv(csv: csv);
      if (step.isReady()) {
        viewModel.setProtectedState(() {
          viewModel.steps = List<ImportModel>.from(viewModel.steps)..add(step);
          viewModel.currentStep = ImportModelColumn(
            column: EImportColumn.defaultValue,
            columnKey: null,
          );
        });
        subject.add(ImportEventMappingColumns());
      } else {
        subject.add(ImportEventInitial());
      }
    } catch (e) {
      subject.add(ImportEventErrorLoadingCsv());
    }
  }
}
