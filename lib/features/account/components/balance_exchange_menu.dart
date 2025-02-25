import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
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

    return ContextMenuComponent(
      offset: 0.0,
      blurBackground: false,
      showBackground: false,
      isActive: isActive,
      buttonBuilder: (context) {
        return SizedBox.square(
          dimension: AppBarComponent.height,
          child: Center(
            child: SvgPicture.asset(
              Assets.icons.arrowDownLeftArrowUpRight,
              width: 28.0,
              height: 28.0,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      },
      itemsBuilder: (context, dismiss) {
        return SeparatedComponent.builder(
          mainAxisSize: MainAxisSize.min,
          itemCount: EBalanceExchangeMenuItem.values.length,
          separatorBuilder: (context, index) {
            return const ContextMenuSeparatorComponent(isBig: false);
          },
          itemBuilder: (context, index) {
            final item = EBalanceExchangeMenuItem.values.elementAt(index);
            return ContextMenuItemComponent(
              label: Text(item.description),
              icon: SvgPicture.asset(
                item.icon,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
              onTap: () {
                final value = (item: item, account: viewModel.account);
                onSendSelected(context, value);
                dismiss();
              },
            );
          },
        );
      },
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
