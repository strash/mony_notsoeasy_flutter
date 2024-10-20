import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/start_account_create/page/view.dart";
import "package:mony_app/features/start_account_create/use_case/use_case.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class StartAccountCreateViewModelBuilder extends StatefulWidget {
  const StartAccountCreateViewModelBuilder({super.key});

  @override
  ViewModelState<StartAccountCreateViewModelBuilder> createState() =>
      StartAccountCreateViewModel();
}

final class StartAccountCreateViewModel
    extends ViewModelState<StartAccountCreateViewModelBuilder> {
  final titleController = InputController();
  final colorController = ColorPickerController(Palette().randomColor);
  final typeController =
      SelectController<EAccountType?>(EAccountType.defaultValue);
  final currencyController =
      SelectController<FiatCurrency?>(FiatCurrency.fromCode("RUB"));
  final balanceController = InputController(
    validators: [AmountValidator()],
  );

  bool isSubmitEnabled = false;

  void _listener() {
    setState(() {
      final balanseTrim = balanceController.text.trim();
      final balanceIsEmptyOrValid = balanseTrim.isEmpty ||
          balanseTrim.isNotEmpty && balanceController.isValid;

      isSubmitEnabled = titleController.isValid &&
          titleController.text.trim().isNotEmpty &&
          colorController.value != null &&
          typeController.value != null &&
          currencyController.value != null &&
          balanceIsEmptyOrValid;
    });
  }

  @override
  void initState() {
    super.initState();
    titleController.addListener(_listener);
    colorController.addListener(_listener);
    typeController.addListener(_listener);
    currencyController.addListener(_listener);
    balanceController.addListener(_listener);
  }

  @override
  void dispose() {
    titleController.removeListener(_listener);
    colorController.removeListener(_listener);
    typeController.removeListener(_listener);
    currencyController.removeListener(_listener);
    balanceController.removeListener(_listener);

    titleController.dispose();
    colorController.dispose();
    typeController.dispose();
    balanceController.dispose();
    currencyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<StartAccountCreateViewModel>(
      viewModel: this,
      useCases: [
        () => OnCreateAccountPressed(),
        () => OnCurrencyDescriptionRequested(),
      ],
      child: const StartAccountCreateView(),
    );
  }
}
