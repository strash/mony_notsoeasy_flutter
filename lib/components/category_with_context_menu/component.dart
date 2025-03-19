import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart" show HapticFeedback;
import "package:flutter_svg/svg.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/double.dart";
import "package:mony_app/components/category/component.dart";
import "package:mony_app/components/category_with_context_menu/use_case/on_context_menu_selected.dart"
    show TCategoryContextMenuValue;
import "package:mony_app/components/context_menu/item.dart";
import "package:mony_app/components/context_menu/menu.dart";
import "package:mony_app/components/context_menu/separator.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

export "./use_case/use_case.dart";

enum ECategoryContextMenuItem {
  edit,
  delete;

  String get icon {
    return switch (this) {
      ECategoryContextMenuItem.edit => Assets.icons.pencil,
      ECategoryContextMenuItem.delete => Assets.icons.trashFill,
    };
  }
}

class CategoryWithContextMenuComponent extends StatefulWidget {
  final CategoryModel category;
  final bool isColorsVisible;
  final UseCase<void, CategoryModel> onTap;
  final UseCase<Future<void>, TCategoryContextMenuValue> onMenuSelected;

  const CategoryWithContextMenuComponent({
    super.key,
    required this.category,
    required this.isColorsVisible,
    required this.onTap,
    required this.onMenuSelected,
  });

  @override
  State<CategoryWithContextMenuComponent> createState() =>
      _CategoryWithContextMenuComponentState();
}

class _CategoryWithContextMenuComponentState
    extends State<CategoryWithContextMenuComponent>
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
            widget.onTap(context, widget.category);
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
                    child: CategoryComponent(
                      category: widget.category,
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
                  child: CategoryComponent(
                    category: widget.category,
                    showColors: widget.isColorsVisible,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      popupBuilder: (context, anim, status, dismiss) {
        final theme = Theme.of(context);

        return SeparatedComponent.builder(
          mainAxisSize: MainAxisSize.min,
          separatorBuilder: (context, index) {
            return const ContextMenuSeparatorComponent(isBig: false);
          },
          itemCount: ECategoryContextMenuItem.values.length,
          itemBuilder: (context, index) {
            final item = ECategoryContextMenuItem.values.elementAt(index);

            return ContextMenuItemComponent(
              label: Text(
                context.t.components.category_with_context_menu.menu_item(
                  context: item,
                ),
              ),
              icon: SvgPicture.asset(
                item.icon,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
              onTap: () {
                final value = (menu: item, category: widget.category);
                widget.onMenuSelected(context, value);
                dismiss();
              },
            );
          },
        );
      },
    );
  }
}
