import "package:flutter/material.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account_with_context_menu/component.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/appbar_button/component.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/account/components/components.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/gen/assets.gen.dart";

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomOffset = NavBarView.bottomOffset(context);
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();

    final viewModel = context.viewModel<AccountViewModel>();
    final account = viewModel.account;
    final balance = viewModel.balance;
    final onEditPressed = viewModel<OnAccountWithContextMenuSelected>();
    final onDeletePressed = viewModel<OnAccountWithContextMenuSelected>();

    final color =
        ex?.from(account.colorName).color ?? theme.colorScheme.onSurface;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> appbar
          AppBarComponent(
            trailing: SeparatedComponent.list(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 4.0);
              },
              children: [
                // -> button edit
                AppBarButtonComponent(
                  icon: Assets.icons.pencilBold,
                  onTap: () {
                    final value = (
                      menu: EAccountContextMenuItem.edit,
                      account: account,
                    );
                    onEditPressed(context, value);
                  },
                ),

                // -> button delete
                AppBarButtonComponent(
                  icon: Assets.icons.trashFill,
                  onTap: () {
                    final value = (
                      menu: EAccountContextMenuItem.delete,
                      account: account,
                    );
                    onDeletePressed(context, value);
                  },
                ),
              ],
            ),
          ),

          // -> content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -> icon
                  AccountIconComponent(
                    account: account,
                    showColors: viewModel.isColorsVisible,
                  ),
                  const SizedBox(height: 40.0),

                  // -> buttons balance exchange
                  const AccountBalanceExchangeMenuComponent(),

                  // -> amount
                  if (balance != null)
                    SeparatedComponent.list(
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 30.0);
                      },
                      children: [
                        // -> total sum
                        AccountTotalSumComponent(
                          balance: balance,
                          showDecimal: true,
                        ),

                        // -> total amount
                        AccountTotalAmountComponent(
                          balance: balance,
                          showDecimal: true,
                        ),

                        // -> currency
                        AccountCurrencyComponent(
                          balance: balance,
                          currencyDescription: viewModel.currencyDescription(
                            balance.currency,
                          ),
                          color: color,
                          showColors: viewModel.isColorsVisible,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // -> bottom offset
          SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
