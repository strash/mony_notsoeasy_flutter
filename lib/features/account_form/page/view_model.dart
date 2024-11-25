import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account_form/page/view.dart";
import "package:mony_app/features/account_form/use_case/use_case.dart";
import "package:provider/provider.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class AccountFormViewModelBuilder extends StatefulWidget {
  final double keyboardHeight;
  final AccountVariant? account;
  final Map<EAccountType, List<String>> additionalUsedTitles;

  const AccountFormViewModelBuilder({
    super.key,
    required this.keyboardHeight,
    required this.account,
    required this.additionalUsedTitles,
  });

  @override
  ViewModelState<AccountFormViewModelBuilder> createState() =>
      AccountFormViewModel();
}

final class AccountFormViewModel
    extends ViewModelState<AccountFormViewModelBuilder> {
  final titleController = InputController();
  final colorController = NamedColorPickerController(EColorName.random());
  final typeController =
      SelectController<EAccountType?>(EAccountType.defaultValue);
  final currencyController = SelectController<FiatCurrency?>(
    FiatCurrency.fromCode(kDefaultCurrencyCode),
  );
  final balanceController = InputController(
    validators: [AmountValidator()],
  );

  bool isSubmitEnabled = false;

  final Map<EAccountType, List<String>> _titles = {
    for (final value in EAccountType.values) value: const [],
  };

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

  Future<void> _fetchData() async {
    final service = context.read<DomainAccountService>();
    final data = await Future.wait(
      EAccountType.values.map((e) => service.getAll(type: e)),
    );
    // set balance to total sum
    if (widget.account case AccountVariantModel(:final model)) {
      final balance = await service.getBalances(ids: [model.id]);
      if (balance.isNotEmpty) {
        balanceController.text =
            balance.first.totalSum.roundToFraction(2).toString();
      }
    }
    for (final list in data) {
      if (list.isEmpty) continue;
      // exclude model from list
      if (widget.account case AccountVariantModel(:final model)) {
        _titles[list.first.type] = List<String>.from(
          list.where((e) => e.id != model.id).map((e) => e.title),
        );
      } else {
        _titles[list.first.type] = List<String>.from(list.map((e) => e.title));
      }
    }
    // append additional user titles
    for (final element in widget.additionalUsedTitles.entries) {
      _titles[element.key] = List<String>.from(_titles[element.key]!)
        ..addAll(element.value);
    }
    _updateTitleController();
  }

  void _updateTitleController() {
    titleController.removeValidator<AccountTitleValidator>();
    titleController.addValidator(
      AccountTitleValidator(titles: _titles[typeController.value]!),
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
    typeController.addListener(_updateTitleController);
    currencyController.addListener(_listener);
    balanceController.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _listener();
      _fetchData();
    });
  }

  @override
  void dispose() {
    titleController.removeListener(_listener);
    colorController.removeListener(_listener);
    typeController.removeListener(_listener);
    typeController.removeListener(_updateTitleController);
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
      useCases: [
        () => OnSumbitAccountPressed(),
        () => OnCurrencyDescriptionRequested(),
      ],
      child: AccountFormView(keyboardHeight: widget.keyboardHeight),
    );
  }
}
