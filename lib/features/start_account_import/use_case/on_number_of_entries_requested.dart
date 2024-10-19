import "package:flutter/widgets.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start_account_import/page/page.dart";

final class OnNumberOfEntriesRequested extends UseCase<String, dynamic> {
  @override
  String call(BuildContext context, [dynamic _]) {
    final viewModel = context.viewModel<StartAccountImportViewModel>();
    final csv = viewModel.csv;
    if (csv == null || csv.entries.isEmpty) return "0 записей";
    final count = csv.entries.length;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(count);
    return switch (count.wordCaseHint) {
      EWordCaseHint.nominative => "$formatted запись",
      EWordCaseHint.genitive => "$formatted записи",
      EWordCaseHint.accusative => "$formatted записей",
    };
  }
}
