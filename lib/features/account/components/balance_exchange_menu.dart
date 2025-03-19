import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account_with_context_menu/component.dart";
import "package:mony_app/features/account/page/view_model.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart"
    show EBalanceExchangeMenuItem;
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class AccountBalanceExchangeMenuComponent extends StatelessWidget {
  const AccountBalanceExchangeMenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewModel = context.viewModel<AccountViewModel>();
    final isActive = viewModel.accountsCount > 1;

    if (!isActive) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        spacing: 10.0,
        children: EBalanceExchangeMenuItem.values
            .map((e) {
              final menu =
                  e == EBalanceExchangeMenuItem.receive
                      ? EAccountContextMenuItem.receive
                      : EAccountContextMenuItem.send;

              return Expanded(
                child: FilledButton(
                  onPressed: () {
                    final value = (menu: menu, account: viewModel.account);
                    viewModel<OnAccountWithContextMenuSelected>()(
                      context,
                      value,
                    );
                  },
                  child: Row(
                    spacing: 8.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // -> title
                      Text(
                        context.t.features.account.menu_item_description(
                          context: e,
                        ),
                      ),

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
}
