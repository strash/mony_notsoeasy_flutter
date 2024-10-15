import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/utils/utils.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/features/start_new_account_create/page/view.dart";
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
  final colorController = ColorPickerController();
  final typeController =
      SelectController<EAccountType?>(EAccountType.defaultValue);
  final currencyController =
      SelectController<FiatCurrency?>(FiatCurrency.fromCode("USD"));
  final balanceController = InputController(
    validators: [CurrencyValidator()],
  );

  late final _locale = Localizations.localeOf(context);
  late final _lang = NaturalLanguage.maybeFromCodeShort(_locale.countryCode);

  String getCurrencyDescription(FiatCurrency? currency) {
    if (currency == null) return "";
    final symbol = currency.symbol ?? "";
    if (_lang != null) {
      final base = BasicLocale(_lang);
      return "${currency.maybeTranslation(base)} $symbol";
    }
    return "${currency.name} $symbol";
  }

  @override
  void dispose() {
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
