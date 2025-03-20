import "package:flutter/material.dart";
import "package:flutter/services.dart" show HapticFeedback;
import "package:flutter_svg/svg.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/double.dart";
import "package:mony_app/components/context_menu/item.dart";
import "package:mony_app/components/context_menu/menu.dart";
import "package:mony_app/components/context_menu/separator.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/components/tag/component.dart";
import "package:mony_app/components/tag_with_context_menu/use_case/on_context_menu_selected.dart"
    show TTagContextMenuValue;
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

export "./use_case/use_case.dart";

enum ETagContextMenuItem {
  edit,
  delete;

  String get icon {
    return switch (this) {
      ETagContextMenuItem.edit => Assets.icons.pencil,
      ETagContextMenuItem.delete => Assets.icons.trashFill,
    };
  }
}

class TagWithContextMenuComponent extends StatefulWidget {
  final TagModel tag;
  final UseCase<void, TagModel> onTap;
  final UseCase<Future<void>, TTagContextMenuValue> onMenuSelected;

  const TagWithContextMenuComponent({
    super.key,
    required this.tag,
    required this.onTap,
    required this.onMenuSelected,
  });

  @override
  State<TagWithContextMenuComponent> createState() =>
      _TagWithContextMenuComponentState();
}

class _TagWithContextMenuComponentState
    extends State<TagWithContextMenuComponent>
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
      offset: const Offset(20.0, 0.0),
      shiftIntoBounds: true,
      buttonBuilder: (context, isOpened, activate) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            widget.onTap(context, widget.tag);
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
                  child: Row(
                    children: [
                      Flexible(
                        child: Opacity(
                          opacity: isOpened ? .0 : 1.0,
                          child: TagComponent(tag: widget.tag),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      buttonProxyBuilder: (context, anim, status, dismiss) {
        final t = Curves.easeInQuad.transform(anim);
        final scale = t.remap(.0, 1.0, 1.0, _scale);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: dismiss,
          child: Transform.scale(
            scale: status == AnimationStatus.reverse ? scale : _scale,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Row(
                children: [Flexible(child: TagComponent(tag: widget.tag))],
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
          itemCount: ETagContextMenuItem.values.length,
          itemBuilder: (context, index) {
            final item = ETagContextMenuItem.values.elementAt(index);

            return ContextMenuItemComponent(
              label: Text(
                context.t.components.tag_with_context_menu.menu_item(
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
                final value = (menu: item, tag: widget.tag);
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
