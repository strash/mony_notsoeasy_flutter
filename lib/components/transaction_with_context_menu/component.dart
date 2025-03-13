import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/app/descriptable/descriptable.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/gen/assets.gen.dart";

export "./use_case/use_case.dart";

enum ETransactionContextMenuItem implements IDescriptable {
  edit,
  delete;

  String get icon {
    return switch (this) {
      ETransactionContextMenuItem.edit => Assets.icons.pencil,
      ETransactionContextMenuItem.delete => Assets.icons.trashFill,
    };
  }

  @override
  String get description {
    return switch (this) {
      ETransactionContextMenuItem.edit => "Редактировать",
      ETransactionContextMenuItem.delete => "Удалить",
    };
  }
}

class TransactionWithContextMenuComponent extends StatefulWidget {
  final TransactionModel transaction;
  final bool isCentsVisible;
  final bool isColorsVisible;
  final bool isTagsVisible;
  final bool showFullDate;
  final UseCase<void, TransactionModel> onTap;
  final UseCase<Future<void>, TTransactionContextMenuValue> onMenuSelected;

  const TransactionWithContextMenuComponent({
    super.key,
    required this.transaction,
    required this.isCentsVisible,
    required this.isColorsVisible,
    required this.isTagsVisible,
    required this.showFullDate,
    required this.onTap,
    required this.onMenuSelected,
  });

  @override
  State<TransactionWithContextMenuComponent> createState() =>
      _TransactionWithContextMenuComponentState();
}

class _TransactionWithContextMenuComponentState
    extends State<TransactionWithContextMenuComponent>
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
            widget.onTap(context, widget.transaction);
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
                    child: TransactionComponent(
                      transaction: widget.transaction,
                      showDecimal: widget.isCentsVisible,
                      showColors: widget.isColorsVisible,
                      showTags: widget.isTagsVisible,
                      showFullDate: widget.showFullDate,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      buttonProxyBuilder: (context, anim, dismiss) {
        final theme = Theme.of(context);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: dismiss,
          child: Transform.scale(
            scale: _scale,
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
                  child: TransactionComponent(
                    transaction: widget.transaction,
                    showDecimal: widget.isCentsVisible,
                    showColors: widget.isColorsVisible,
                    showTags: widget.isTagsVisible,
                    showFullDate: widget.showFullDate,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      popupBuilder: (context, anim, dismiss) {
        final theme = Theme.of(context);

        return SeparatedComponent.builder(
          mainAxisSize: MainAxisSize.min,
          separatorBuilder: (context, index) {
            return const ContextMenuSeparatorComponent(isBig: false);
          },
          itemCount: ETransactionContextMenuItem.values.length,
          itemBuilder: (context, index) {
            final item = ETransactionContextMenuItem.values.elementAt(index);

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
                dismiss();
                final value = (menu: item, transaction: widget.transaction);
                widget.onMenuSelected(context, value);
              },
            );
          },
        );
      },
    );
  }
}
