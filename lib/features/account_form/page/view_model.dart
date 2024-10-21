import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account_form/page/view.dart";
import "package:mony_app/features/account_form/use_case/use_case.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class AccountFormViewModelBuilder extends StatefulWidget {
  final AccountVO? account;
  final ScrollController scrollController;

  const AccountFormViewModelBuilder({
    super.key,
    this.account,
    required this.scrollController,
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

  bool get isCreating => widget.account == null;

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
    currencyController.addListener(_listener);
    balanceController.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _listener();
    });
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
    return ViewModel<AccountFormViewModel>(
      viewModel: this,
      useCases: [
        () => OnCreateAccountPressed(),
        () => OnCurrencyDescriptionRequested(),
      ],
      child: AccountFormView(
        scrollController: widget.scrollController,
      ),
    );
  }
}
