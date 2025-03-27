import "dart:math";

import "package:emoji_picker_flutter/emoji_picker_flutter.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/common/utils/utils.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

part "./category_view.dart";

class EmojiPickerComponent extends StatefulWidget {
  final InputController controller;

  const EmojiPickerComponent({super.key, required this.controller});

  @override
  State<EmojiPickerComponent> createState() => _EmojiPickerComponentState();
}

class _EmojiPickerComponentState extends State<EmojiPickerComponent> {
  bool _isActive = false;

  final _emojiSet = defaultEmojiSet
      .map((e) {
        return (e.category == Category.OBJECTS)
            ? e.copyWith(
              category: e.category,
              emoji: List<Emoji>.of(e.emoji)
                ..add(const Emoji("🛒", "Shopping Cart")),
            )
            : e;
      })
      .toList(growable: false);

  Future<void> _onTap(BuildContext context) async {
    setState(() => _isActive = true);
    final current = widget.controller.text;
    await BottomSheetComponent.show<void>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        final colorScheme = ColorScheme.of(context);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // -> appbar
            AppBarComponent(
              title: Text(context.t.components.emoji_picker.title),
              useSliver: false,
              showDragHandle: true,
              showBackground: false,
            ),

            // -> picker
            EmojiPicker(
              textEditingController: widget.controller.controller,
              config: Config(
                emojiSet: (locale) => _emojiSet,
                height: MediaQuery.sizeOf(context).height * 0.48,
                emojiViewConfig: EmojiViewConfig(
                  emojiSizeMax: 38.0,
                  columns: 7,
                  backgroundColor: colorScheme.surface,
                  buttonMode: ButtonMode.CUPERTINO,
                  gridPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, bottom),
                ),
                skinToneConfig: const SkinToneConfig(enabled: false),
                categoryViewConfig: CategoryViewConfig(
                  customCategoryView: (config, state, tab, page) {
                    return _CategoryView(config, state, tab, page);
                  },
                  recentTabBehavior: RecentTabBehavior.NONE,
                  backgroundColor: colorScheme.surface,
                  indicatorColor: colorScheme.primary,
                  iconColor: colorScheme.primaryContainer,
                  iconColorSelected: colorScheme.primary,
                  dividerColor: const Color(0x00FFFFFF),
                  backspaceColor: colorScheme.primary,
                ),
                bottomActionBarConfig: const BottomActionBarConfig(
                  enabled: false,
                ),
              ),
              onEmojiSelected: (category, emoji) {
                widget.controller.text = emoji.emoji;
                Navigator.of(context).pop<void>();
              },
              onBackspacePressed: () {
                widget.controller.text = current;
              },
            ),
          ],
        );
      },
    );
    setState(() => _isActive = false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(context),
      child: SizedBox.square(
        dimension: 48.0,
        child: TweenAnimationBuilder<Color?>(
          duration: Durations.short2,
          tween: ColorTween(
            begin: colorScheme.secondary.withValues(alpha: 0.0),
            end: colorScheme.secondary.withValues(alpha: _isActive ? 1.0 : 0.0),
          ),
          builder: (context, color, child) {
            // -> background
            return DecoratedBox(
              decoration: ShapeDecoration(
                color: colorScheme.surfaceContainer,
                shape: Smooth.border(16.0, BorderSide(color: color!)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListenableBuilder(
                  listenable: widget.controller.controller,
                  builder: (context, child) {
                    // -> emoji
                    return Center(
                      child: Text(
                        widget.controller.text,
                        style: TextTheme.of(
                          context,
                        ).bodyLarge?.copyWith(fontSize: 30.0, height: .0),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
