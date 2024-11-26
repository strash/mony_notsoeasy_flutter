import "package:flutter/material.dart";
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

    final viewModel = context.viewModel<AccountViewModel>();
    final account = viewModel.account;
    final balance = viewModel.balance;
    final onEditPressed = viewModel<OnEditAccountPressed>();
    final onDeletePressed = viewModel<OnDeleteAccountPressed>();

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> appbar
          AppBarComponent(
            showBackground: false,
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
                const SizedBox(width: 8.0),
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
                        // -> total sum title
                        AccountTotalSumComponent(balance: balance),

                        // -> total amount title
                        AccountTotalAmountComponent(balance: balance),

                        // -> currency title
                        AccountCurrencyComponent(balance: balance),
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
