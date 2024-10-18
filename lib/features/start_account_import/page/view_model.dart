import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/start_account_import/page/event.dart";
import "package:mony_app/features/start_account_import/page/view.dart";
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

  late final onSelectFilePressed = OnSelectFilePressedUseCase();
  late final onBackwardPressed = OnBackwardPressedUseCase();
  late final onForwardPressed = OnForwardPressedUseCase();
  final onRotateEntryPressed = OnRotateEntryPressedUseCase();
  final onColumnSelected = OnColumnSelectedUseCase();
  final onCurrentCsvEntryRequested = OnCurrentCsvEntryRequestedUseCase();
  final onNumberOfEntriesRequested = OnNumberOfEntriesRequestedUseCase();
  final onSelectedColumnNameRequested = OnSelectedColumnNameRequestedUseCase();

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
    OnImportEventChangedUseCase().call(context, this);
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
      child: const StartAccountImportView(),
    );
  }
}
