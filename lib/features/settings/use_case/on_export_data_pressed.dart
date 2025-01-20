import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/services/services.dart";
import "package:provider/provider.dart";

final class OnExportDataPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final accountService = context.read<DomainAccountService>();
    final categoryService = context.read<DomainCategoryService>();
    final tagService = context.read<DomainTagService>();
    final transactionService = context.read<DomainTransactionService>();
    final importExportService = context.read<DomainImportExportService>();

    final rec = await transactionService.dumpData();
    final Map<String, dynamic> data = {
      "version": const String.fromEnvironment("MIGRATE_VERSION"),
      "name": "mony_app",
      "date": DateTime.now().toUtc().toIso8601String(),
      "accounts": await accountService.dumpData(),
      "categories": await categoryService.dumpData(),
      "tags": await tagService.dumpData(),
      "transactions": rec.transactions,
      "transaction_tags": rec.transactionTags,
    };
    await importExportService.exportData(data);
  }
}
