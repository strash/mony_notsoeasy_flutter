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
    final theme = Theme.of(context);
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<AccountsViewModel>();
    final onAddAccountPressed = viewModel<OnAddAccountPressed>();
    final onAccountPressed = viewModel<OnAccountPressed>();
    final isEmpty = viewModel.accounts.isEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        controller: viewModel.controller,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> appbar
          AppBarComponent(
            title: const Text("Счета"),
            trailing: AppBarButtonComponent(
              icon: Assets.icons.plus,
              onTap: () => onAddAccountPressed(context),
            ),
          ),

          // -> empty state
          if (isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomOffset),
                child: EmptyStateComponent(color: theme.colorScheme.onSurface),
              ),
            )
          // -> accounts
          else
            SliverPadding(
              padding: const EdgeInsets.only(top: 20.0),
              sliver: SliverList.separated(
                findChildIndexCallback: (key) {
                  final id = (key as ValueKey).value;
                  final index = viewModel.accounts.indexWhere(
                    (e) => e.id == id,
                  );
                  return index != -1 ? index : null;
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 25.0);
                },
                itemCount: viewModel.accounts.length,
                itemBuilder: (context, index) {
                  final item = viewModel.accounts.elementAt(index);
                  final balance = viewModel.balances.elementAtOrNull(index);

                  return GestureDetector(
                    key: ValueKey<String>(item.id),
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onAccountPressed(context, item),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: AccountComponent(
                        account: item,
                        balance: balance,
                        showColors: viewModel.isColorsVisible,
                        showCents: viewModel.isCentsVisible,
                      ),
                    ),
                  );
                },
              ),
            ),

          // -> bottom offset
          if (!isEmpty)
            SliverToBoxAdapter(child: SizedBox(height: bottomOffset)),
        ],
      ),
    );
  }
}
