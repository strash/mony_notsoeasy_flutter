import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account_form/page/view.dart";
import "package:mony_app/features/account_form/use_case/use_case.dart";
import "package:provider/provider.dart";
import "package:sealed_currencies/sealed_currencies.dart";

export "../use_case/use_case.dart";

final class AccountFormViewModelBuilder extends StatefulWidget {
  final double keyboardHeight;
  final AccountVO? account;
  final Map<EAccountType, List<String>> titles;

  const AccountFormViewModelBuilder({
    super.key,
    required this.keyboardHeight,
    required this.account,
    required this.titles,
  });

  @override
  ViewModelState<AccountFormViewModelBuilder> createState() =>
      AccountFormViewModel();
}

final class AccountFormViewModel
    extends ViewModelState<AccountFormViewModelBuilder> {
  final titleController = InputController();
  final colorController = ColorPickerController(Palette().randomColor);
  final typeController =
      SelectController<EAccountType?>(EAccountType.defaultValue);
  final currencyController = SelectController<FiatCurrency?>(
    FiatCurrency.fromCode(kDefaultCurrencyCode),
  );
  final balanceController = InputController(
    validators: [AmountValidator()],
  );

  bool isSubmitEnabled = false;

  final Map<EAccountType, List<String>> _accounts = {
    for (final value in EAccountType.values) value: const <String>[],
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

  Future<void> _fetchAccounts() async {
    final service = context.read<DomainAccountService>();
    final accounts = await Future.wait(
      EAccountType.values.map((e) => service.getAll(type: e)),
    );
    for (final list in accounts) {
      if (list.isEmpty) continue;
      final account = list.first;
      _accounts[account.type] =
          List<String>.from(list.map<String>((e) => e.title));
    }
    for (final element in widget.titles.entries) {
      _accounts[element.key] = List<String>.from(_accounts[element.key]!)
        ..addAll(element.value);
    }
    _updateTitleController();
  }

  void _updateTitleController() {
    titleController.removeValidator<AccountValidator>();
    titleController.addValidator<AccountValidator>(
      AccountValidator(
        titles: List<String>.from(_accounts[typeController.value]!),
      ),
    );
    _listener();
  }

  @override
  void initState() {
    super.initState();
    final account = widget.account;
    if (account != null) {
      titleController.text = account.title;
      colorController.value = account.color;
      typeController.value = account.type;
      currencyController.value = FiatCurrency.fromCode(account.currencyCode);
      balanceController.text = account.balance.toString();
    }
    titleController.addListener(_listener);
    colorController.addListener(_listener);
    typeController.addListener(_listener);
    typeController.addListener(_updateTitleController);
    currencyController.addListener(_listener);
    balanceController.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _listener();
      _fetchAccounts();
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
