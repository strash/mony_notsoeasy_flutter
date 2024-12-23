import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/accounts/page/view_model.dart";
import "package:mony_app/features/accounts/use_case/use_case.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/gen/assets.gen.dart";

class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<AccountsViewModel>();
    final onAddAccountPressed = viewModel<OnAddAccountPressed>();
    final onAccountPressed = viewModel<OnAccountPressed>();

    return Scaffold(
      body: CustomScrollView(
        controller: viewModel.controller,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> appbar
          AppBarComponent(
            title: const Text("Счета"),
            trailing: Row(
              children: [
                // -> button add
                AppBarButtonComponent(
                  icon: Assets.icons.plus,
                  onTap: () => onAddAccountPressed(context),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
          ),

          // -> accounts
          SliverPadding(
            padding: const EdgeInsets.only(top: 10.0),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 20.0);
              },
              itemCount: viewModel.accounts.length,
              itemBuilder: (context, index) {
                final item = viewModel.accounts.elementAt(index);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onAccountPressed(context, item),
                    child: AccountComponent(account: item),
                  ),
                );
              },
            ),
          ),

          // -> bottom offset
          SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
