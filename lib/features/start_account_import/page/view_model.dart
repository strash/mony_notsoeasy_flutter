import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/start_account_import/page/view.dart";
import "package:mony_app/features/start_account_import/start_account_import.dart";
import "package:mony_app/features/start_account_import/use_case/use_case.dart";
import "package:rxdart/subjects.dart";

final class StartAccountImportViewModelBuilder extends StatefulWidget {
  const StartAccountImportViewModelBuilder({super.key});

  @override
  ViewModelState<StartAccountImportViewModelBuilder> createState() =>
      StartAccountImportViewModel();
}

final class StartAccountImportViewModel
    extends ViewModelState<StartAccountImportViewModelBuilder> {
  final subject = BehaviorSubject<ImportEvent>.seeded(ImportEventInitial());

  int progress = 0;

  int get progressPercentage => (progress * 100 / _totalProgress).round();

  // TODO: указать правильное количество шагов
  final _totalProgress = 11;

  ImportedCsvValueObject? csv;

  MappedCsvColumnsValueObject mappedCsvColumns =
      const MappedCsvColumnsValueObject(
    account: null,
    amount: null,
    expenseType: null,
    date: null,
    category: null,
    tag: null,
    note: null,
  );

  int currentEntryIndex = 0;

  String currentColumn = "Счет";

  @override
  void initState() {
    super.initState();
    OnImportEventChanged().call(context, this);
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<StartAccountImportViewModel>(
      viewModel: this,
      useCases: [
        () => OnSelectFilePressed(),
        () => OnBackwardPressed(),
        () => OnForwardPressed(),
        () => OnRotateEntryPressed(),
        () => OnColumnSelected(),
        () => OnCurrentCsvEntryRequested(),
        () => OnNumberOfEntriesRequested(),
        () => OnSelectedColumnNameRequested(),
      ],
      child: const StartAccountImportView(),
    );
  }
}
