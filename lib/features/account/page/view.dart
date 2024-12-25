import "package:flutter/material.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/account/components/components.dart";
import "package:mony_app/features/account/use_case/use_case.dart";
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
    final onEditPressed = viewModel<OnEditPressed>();
    final onDeletePressed = viewModel<OnDeletePressed>();

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
            trailing: Row(
              children: [
                // -> button edit
                AppBarButtonComponent(
                  icon: Assets.icons.pencilBold,
                  onTap: () => onEditPressed(context, account),
                ),
                const SizedBox(width: 4.0),

                // -> button delete
                AppBarButtonComponent(
                  icon: Assets.icons.trashFill,
                  onTap: () => onDeletePressed(context, account),
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
                  AccountIconComponent(account: account),
                  const SizedBox(height: 40.0),

                  // -> amount
                  if (balance != null)
                    SeparatedComponent.list(
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 30.0);
                      },
                      children: [
                        // -> total sum
                        AccountTotalSumComponent(balance: balance),

                        // -> total amount
                        AccountTotalAmountComponent(balance: balance),

                        // -> currency
                        AccountCurrencyComponent(
                          balance: balance,
                          color: color,
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
