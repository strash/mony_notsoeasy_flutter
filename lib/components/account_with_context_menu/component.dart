import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/app/descriptable/descriptable.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/double.dart";
import "package:mony_app/components/account/component.dart";
import "package:mony_app/components/account_with_context_menu/use_case/on_context_menu_selected.dart"
    show TAccountContextMenuValue;
import "package:mony_app/components/context_menu/component.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/models/account_balance.dart";
import "package:mony_app/gen/assets.gen.dart";

export "./use_case/use_case.dart";

enum EAccountContextMenuItem implements IDescriptable {
  receive,
  send,
  edit,
  delete;

  String get icon {
    return switch (this) {
      EAccountContextMenuItem.receive => Assets.icons.arrowDownBackward,
      EAccountContextMenuItem.send => Assets.icons.arrowUpForward,
      EAccountContextMenuItem.edit => Assets.icons.pencil,
      EAccountContextMenuItem.delete => Assets.icons.trashFill,
    };
  }

  @override
  String get description {
    return switch (this) {
      EAccountContextMenuItem.receive => "Пополнить",
      EAccountContextMenuItem.send => "Перевести",
      EAccountContextMenuItem.edit => "Редактировать",
      EAccountContextMenuItem.delete => "Удалить",
    };
  }
}

class AccountWithContextMenuComponent extends StatefulWidget {
  final int accountCount;
  final AccountModel account;
  final AccountBalanceModel? balance;
  final bool isCentsVisible;
  final bool isColorsVisible;
  final UseCase<void, AccountModel> onTap;
  final UseCase<Future<void>, TAccountContextMenuValue> onMenuSelected;

  const AccountWithContextMenuComponent({
    super.key,
    required this.accountCount,
    required this.account,
    this.balance,
    required this.isCentsVisible,
    required this.isColorsVisible,
    required this.onTap,
    required this.onMenuSelected,
  });

  @override
  State<AccountWithContextMenuComponent> createState() =>
      _AccountWithContextMenuComponentState();
}

class _AccountWithContextMenuComponentState
    extends State<AccountWithContextMenuComponent>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: Durations.long2,
  );

  final _scale = 1.015;

  void _onLongPress(VoidCallback activate) {
    HapticFeedback.heavyImpact();
    activate();
    _controller.reset();
  }

  Widget _getMenuItem(EAccountContextMenuItem item, VoidCallback dismiss) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);

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
            final value = (menu: item, account: widget.account);
            widget.onMenuSelected(context, value);
            dismiss();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContextMenuComponent(
      offset: const Offset(10.0, 10.0),
      shiftIntoBounds: true,
      buttonBuilder: (context, isOpened, activate) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            widget.onTap(context, widget.account);
          },
          onLongPressDown: (_) {
            _controller.forward();
          },
          onLongPressCancel: () {
            _controller.reverse();
          },
          onLongPress: isOpened ? null : () => _onLongPress(activate),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final scale = _controller.value.remap(.0, 1.0, 1.0, _scale);

              return Transform.scale(
                scale: !isOpened ? scale : 1.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Opacity(
                    opacity: isOpened ? .0 : 1.0,
                    child: AccountComponent(
                      account: widget.account,
                      balance: widget.balance,
                      showDecimal: widget.isCentsVisible,
                      showColors: widget.isColorsVisible,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      buttonProxyBuilder: (context, anim, status, dismiss) {
        final theme = Theme.of(context);
        final t = Curves.easeInQuad.transform(anim);
        final scale = t.remap(.0, 1.0, 1.0, _scale);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: dismiss,
          child: Transform.scale(
            scale: status == AnimationStatus.reverse ? scale : _scale,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: theme.colorScheme.surface,
                  shape: const SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.all(
                      SmoothRadius(cornerRadius: 23.0, cornerSmoothing: .6),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AccountComponent(
                    account: widget.account,
                    balance: widget.balance,
                    showDecimal: widget.isCentsVisible,
                    showColors: widget.isColorsVisible,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      popupBuilder: (context, anim, status, dismiss) {
        final hasAccounts = widget.accountCount > 1;

        return SeparatedComponent.list(
          mainAxisSize: MainAxisSize.min,
          separatorBuilder: (context, index) {
            return const ContextMenuSeparatorComponent(isBig: false);
          },
          children: [
            if (hasAccounts)
              _getMenuItem(EAccountContextMenuItem.receive, dismiss),
            if (hasAccounts)
              _getMenuItem(EAccountContextMenuItem.send, dismiss),
            _getMenuItem(EAccountContextMenuItem.edit, dismiss),
            _getMenuItem(EAccountContextMenuItem.delete, dismiss),
          ],
        );
      },
    );
  }
}
