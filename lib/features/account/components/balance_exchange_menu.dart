import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/account/page/view_model.dart";
import "package:mony_app/features/account/use_case/on_balance_exchange_menu_selected.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart"
    show EBalanceExchangeMenuItem;
import "package:mony_app/gen/assets.gen.dart";

class AccountBalanceExchangeMenuComponent extends StatelessWidget {
  const AccountBalanceExchangeMenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<AccountViewModel>();
    final isActive = viewModel.accountsCount > 1;
    final onSendSelected = viewModel<OnBalanceExchangeMenuSelected>();

    if (!isActive) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        spacing: 10.0,
        children: EBalanceExchangeMenuItem.values
            .map((e) {
              return Expanded(
                child: FilledButton(
                  onPressed: () {
                    final value = (item: e, account: viewModel.account);
                    onSendSelected(context, value);
                  },
                  child: Row(
                    spacing: 8.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // -> title
                      Text(e.description),

                      // -> icon
                      SvgPicture.asset(
                        e.icon,
                        width: 22.0,
                        height: 22.0,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.onPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

extension on EBalanceExchangeMenuItem {
  String get icon {
    return switch (this) {
      EBalanceExchangeMenuItem.receive => Assets.icons.arrowDownBackward,
      EBalanceExchangeMenuItem.send => Assets.icons.arrowUpForward,
    };
  }

  String get description {
    return switch (this) {
      EBalanceExchangeMenuItem.receive => "Пополнить",
      EBalanceExchangeMenuItem.send => "Перевести",
    };
  }
}
