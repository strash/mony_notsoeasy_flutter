import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account/component.dart";
import "package:mony_app/components/account_select/component.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class BalanceExchangeFormReceiveOrderComponent extends StatelessWidget {
  const BalanceExchangeFormReceiveOrderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();

    return SeparatedComponent.list(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10.0);
      },
      children: [
        // -> account select
        AccountSelectComponent(
          controller: viewModel.accountController,
          accounts: viewModel.accounts,
          isColorsVisible: viewModel.isColorsVisible,
        ),

        // -> icon arrow
        SvgPicture.asset(
          Assets.icons.arrowDownCircleDotted,
          width: 40.0,
          height: 40.0,
          colorFilter: ColorFilter.mode(
            theme.colorScheme.primaryContainer,
            BlendMode.srcIn,
          ),
        ),

        // -> active account
        AccountComponent(
          account: viewModel.account,
          showColors: viewModel.isColorsVisible,
          showCurrencyTag: true,
        ),
      ],
    );
  }
}
