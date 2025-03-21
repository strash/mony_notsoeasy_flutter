import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/services/services.dart";

final class OnExportDataPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final accountService = context.service<DomainAccountService>();
    final categoryService = context.service<DomainCategoryService>();
    final tagService = context.service<DomainTagService>();
    final transactionService = context.service<DomainTransactionService>();
    final importExportService = context.service<DomainImportExportService>();

    final rec = await transactionService.dumpData();
    final Map<String, dynamic> data = {
      "version": kSupportEmail,
      "build_name": kBuildName,
      "build_number": kBuildNumber,
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
