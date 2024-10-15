import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/utils/utils.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/start_new_account_create/page/view.dart";
import "package:mony_app/features/start_new_account_create/use_case/use_case.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class StartNewAccountCreateViewModelBuilder extends StatefulWidget {
  const StartNewAccountCreateViewModelBuilder({super.key});

  @override
  ViewModelState<StartNewAccountCreateViewModelBuilder> createState() =>
      StartNewAccountCreateViewModel();
}

final class StartNewAccountCreateViewModel
    extends ViewModelState<StartNewAccountCreateViewModelBuilder> {
  final titleController = InputController();
  final colorController = ColorPickerController(Palette().randomColor);
  final typeController =
      SelectController<EAccountType?>(EAccountType.defaultValue);
  final currencyController =
      SelectController<FiatCurrency?>(FiatCurrency.fromCode("USD"));
  final balanceController = InputController(
    validators: [CurrencyValidator()],
  );

  final onCreateAccountPressed = OnCreateAccountPressedUseCase();

  bool isSubmitEnabled = false;

  late final _locale = Localizations.localeOf(context);
  late final _lang = NaturalLanguage.maybeFromCodeShort(_locale.countryCode);

  AccountValueObject get value {
    String balance = balanceController.text.trim();
    balance = balance.replaceAll(",", ".");
    return AccountValueObject.create(
      title: titleController.text.trim(),
      color: colorController.value ?? Palette().randomColor,
      type: typeController.value ?? EAccountType.defaultValue,
      currencyCode: currencyController.value?.code ?? "USD",
      balance: double.tryParse(balance) ?? 0.0,
    );
  }

  String getCurrencyDescription(FiatCurrency? currency) {
    if (currency == null) return "";
    final symbol = currency.symbol ?? "";
    if (_lang != null) {
      final base = BasicLocale(_lang);
      return "${currency.maybeTranslation(base)} $symbol";
    }
    return "${currency.name} $symbol";
  }

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
    return ViewModel<StartNewAccountCreateViewModel>(
      viewModel: this,
      child: const StartNewAccountCreateView(),
    );
  }
}
