import "package:flutter/material.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/account_with_context_menu/component.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/appbar_button/component.dart";
import "package:mony_app/components/empty_state/component.dart";
import "package:mony_app/features/accounts/page/view_model.dart";
import "package:mony_app/features/accounts/use_case/use_case.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  String get _keyPrefix => "accounts";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomOffset = NavBarView.bottomOffset(context);

    final viewModel = context.viewModel<AccountsViewModel>();
    final onAddAccountPressed = viewModel<OnAddAccountPressed>();
    final onAccountPressed = viewModel<OnAccountPressed>();
    final onAccountMenuSelected = viewModel<OnAccountWithContextMenuSelected>();

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
            title: Text(context.t.features.accounts.title),
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
                  final index = viewModel.accounts.indexWhere((e) {
                    return "${_keyPrefix}_${e.id}" == id;
                  });
                  return index != -1 ? index : null;
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 5.0);
                },
                itemCount: viewModel.accounts.length,
                itemBuilder: (context, index) {
                  final item = viewModel.accounts.elementAt(index);
                  final balance = viewModel.balances.elementAtOrNull(index);

                  return AccountWithContextMenuComponent(
                    key: ValueKey<String>("${_keyPrefix}_${item.id}"),
                    account: item,
                    accountCount: viewModel.accounts.length,
                    balance: balance,
                    isCentsVisible: viewModel.isCentsVisible,
                    isColorsVisible: viewModel.isColorsVisible,
                    onTap: onAccountPressed,
                    onMenuSelected: onAccountMenuSelected,
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
