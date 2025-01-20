import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/services/filesystem/import_export.dart";
import "package:provider/provider.dart";

final class OnImportDataPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final importExportService = context.read<DomainImportExportService>();
    final data = await importExportService.importMONY();
    if (data == null) return;
    print(data);
  }
}
