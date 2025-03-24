import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";
import "package:url_launcher/url_launcher.dart";

final class OnCurrencyLinkPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();
    final leftCurrency = viewModel.leftBalance?.currency;
    final rightCurrency = viewModel.rightBalance?.currency;

    if (leftCurrency == null || rightCurrency == null) return;

    // https://duckduckgo.com/?q=1+rub+to+eur
    final amount =
        double.tryParse(viewModel.amountController.text.trim()) ?? .0;
    final query = "$amount ${leftCurrency.code} to ${rightCurrency.code}";
    final url = Uri.https("duckduckgo.com", "", {"q": query});
    if (await canLaunchUrl(url) && context.mounted) {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    }
  }
}
