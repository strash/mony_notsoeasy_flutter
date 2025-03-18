import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/services/services.dart";
import "package:mony_app/features/features.dart";

final class OnImportDataPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final viewModel = context.viewModel<SettingsViewModel>();

    viewModel.setProtectedState(() {
      viewModel.isImportInProgress = true;
    });

    final importExportService = context.service<DomainImportExportService>();
    final data = await importExportService.importMONY();

    if (data == null ||
        data["version"] == null ||
        data["name"] == null ||
        data["build_name"] == null ||
        data["build_number"] == null ||
        !context.mounted) {
      viewModel.setProtectedState(() {
        viewModel.isImportInProgress = false;
      });
      return;
    }

    final accountService = context.service<DomainAccountService>();
    final categoryService = context.service<DomainCategoryService>();
    final tagService = context.service<DomainTagService>();
    final transactionService = context.service<DomainTransactionService>();
    final appService = context.viewModel<AppEventService>();

    final accounts = _getValue(key: "accounts", map: data);
    if (accounts != null) {
      for (final element in accounts) {
        final value = _getElement(element);
        if (value == null) continue;
        final vo = AccountVO.from(value);
        if (vo == null) continue;
        await accountService.create(vo: vo);
      }
    }

    final categories = _getValue(key: "categories", map: data);
    if (categories != null) {
      for (final element in categories) {
        final value = _getElement(element);
        if (value == null) continue;
        final vo = CategoryVO.from(value);
        if (vo == null) continue;
        await categoryService.create(vo: vo);
      }
    }

    final tags = _getValue(key: "tags", map: data);
    if (tags != null) {
      for (final element in tags) {
        final value = _getElement(element);
        if (value == null) continue;
        final vo = TagVO.from(value);
        if (vo == null) continue;
        await tagService.create(vo: vo);
      }
    }

    final transactions = _getValue(key: "transactions", map: data);
    if (transactions != null) {
      for (final element in transactions) {
        final value = _getElement(element);
        if (value == null) continue;
        final vo = TransactionVO.from(value);
        if (vo == null) continue;
        await transactionService.create(vo: vo, tags: []);
      }
    }

    final transactionTags = _getValue(key: "transaction_tags", map: data);
    if (transactionTags != null) {
      for (final element in transactionTags) {
        final value = _getElement(element);
        if (value == null) continue;
        final vo = TransactionTagVO.from(value);
        if (vo == null) continue;
        await transactionService.createTransactionTag(vo);
      }
    }

    viewModel.setProtectedState(() {
      viewModel.isImportInProgress = false;
    });

    appService.notify(EventDataImported());
  }

  List<dynamic>? _getValue({
    required String key,
    required Map<String, dynamic> map,
  }) {
    return map.containsKey(key) && map[key] is List<dynamic>
        ? map[key] as List<dynamic>
        : null;
  }

  Map<String, dynamic>? _getElement(dynamic element) {
    return element is Map<String, dynamic> ? element : null;
  }
}
