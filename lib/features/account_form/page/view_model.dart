import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account_form/page/view.dart";
import "package:mony_app/features/account_form/use_case/use_case.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class AccountFormPage extends StatefulWidget {
  final double keyboardHeight;
  final AccountVariant? account;
  final Map<EAccountType, List<String>> additionalUsedTitles;

  const AccountFormPage({
    super.key,
    required this.keyboardHeight,
    required this.account,
    required this.additionalUsedTitles,
  });

  @override
  ViewModelState<AccountFormPage> createState() => AccountFormViewModel();
}

final class AccountFormViewModel extends ViewModelState<AccountFormPage> {
  final titleController = InputController();
  final colorController = NamedColorPickerController(EColorName.random());
  final typeController = SelectController<EAccountType?>(
    EAccountType.defaultValue,
  );
  final currencyController = SelectController<FiatCurrency?>(
    FiatCurrency.fromCode(kDefaultCurrencyCode),
  );
  final balanceController = InputController(validators: [AmountValidator()]);

  bool isSubmitEnabled = false;

  final Map<EAccountType, List<String>> titles = {
    for (final value in EAccountType.values) value: const [],
  };

  AccountVariant? get account {
    return widget.account;
  }

  Map<EAccountType, List<String>> get additionalUsedTitles {
    return widget.additionalUsedTitles;
  }

  List<FiatCurrency> get currencies {
    return List.of(FiatCurrency.list.nonNulls, growable: false)
      ..sort((a, b) => a.code.compareTo(b.code));
  }

  Iterable<(String, String)> get currencyDescriptions {
    return currencies.map((currency) {
      final locale = Localizations.localeOf(context);
      final lang = NaturalLanguage.maybeFromCodeShort(locale.countryCode);
      final symbol = currency.symbol ?? "";
      if (lang != null) {
        final base = BasicLocale(lang);
        return (symbol, currency.maybeTranslation(base)?.toString() ?? "");
      }
      return (symbol, currency.name);
    });
  }

  void _listener() {
    setProtectedState(() {
      final balanseTrim = balanceController.text.trim();
      final balanceIsEmptyOrValid =
          balanseTrim.isEmpty ||
          balanseTrim.isNotEmpty && balanceController.isValid;

      isSubmitEnabled =
          titleController.isValid &&
          titleController.text.trim().isNotEmpty &&
          colorController.value != null &&
          typeController.value != null &&
          currencyController.value != null &&
          balanceIsEmptyOrValid;
    });
  }

  void updateTitleController() {
    titleController.removeValidator<AccountTitleValidator>();
    titleController.addValidator(
      AccountTitleValidator(titles: titles[typeController.value]!),
    );
    _listener();
  }

  @override
  void initState() {
    super.initState();
    final account = widget.account;
    if (account != null) {
      switch (account) {
        case AccountVariantVO(:final vo):
          titleController.text = vo.title;
          colorController.value = EColorName.from(vo.colorName);
          typeController.value = vo.type;
          currencyController.value = FiatCurrency.fromCode(vo.currencyCode);
          balanceController.text = vo.balance.roundToFraction(2).toString();
        case AccountVariantModel(:final model):
          titleController.text = model.title;
          colorController.value = model.colorName;
          typeController.value = model.type;
          currencyController.value = FiatCurrency.fromCode(model.currency.code);
          balanceController.text = model.balance.roundToFraction(2).toString();
      }
    }
    titleController.addListener(_listener);
    colorController.addListener(_listener);
    typeController.addListener(_listener);
    typeController.addListener(updateTitleController);
    currencyController.addListener(_listener);
    balanceController.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _listener();
      OnInit().call(context, this);
    });
  }

  @override
  void dispose() {
    titleController.removeListener(_listener);
    colorController.removeListener(_listener);
    typeController.removeListener(_listener);
    typeController.removeListener(updateTitleController);
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
    return ViewModel<AccountFormViewModel>(
      viewModel: this,
      useCases: [() => OnSumbitPressed()],
      child: AccountFormView(keyboardHeight: widget.keyboardHeight),
    );
  }
}
