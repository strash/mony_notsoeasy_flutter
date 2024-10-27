import "package:emoji_picker_flutter/emoji_picker_flutter.dart";
import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/common/utils/utils.dart";
import "package:mony_app/components/components.dart";

class EmojiPickerComponent extends StatefulWidget {
  final InputController controller;

  const EmojiPickerComponent({
    super.key,
    required this.controller,
  });

  @override
  State<EmojiPickerComponent> createState() => _EmojiPickerComponentState();
}

class _EmojiPickerComponentState extends State<EmojiPickerComponent> {
  bool _isActive = false;

  Future<void> _onTap(BuildContext context) async {
    setState(() => _isActive = true);
    final current = widget.controller.text;
    await BottomSheetComponent.show<void>(
      context,
      builder: (context, bottom) {
        final theme = Theme.of(context);

        return EmojiPicker(
          textEditingController: widget.controller.controller,
          config: Config(
            height: MediaQuery.sizeOf(context).height * 0.48,
            emojiViewConfig: EmojiViewConfig(
              emojiSizeMax: 30,
              columns: 9,
              backgroundColor: Theme.of(context).colorScheme.surface,
              buttonMode: ButtonMode.CUPERTINO,
              gridPadding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, bottom),
            ),
            skinToneConfig: const SkinToneConfig(enabled: false),
            categoryViewConfig: CategoryViewConfig(
              recentTabBehavior: RecentTabBehavior.NONE,
              backgroundColor: theme.colorScheme.surface,
              indicatorColor: theme.colorScheme.primary,
              iconColor: theme.colorScheme.primaryContainer,
              iconColorSelected: theme.colorScheme.primary,
              dividerColor: const Color(0x00000000),
              backspaceColor: theme.colorScheme.primary,
            ),
            bottomActionBarConfig: const BottomActionBarConfig(enabled: false),
          ),
          onEmojiSelected: (category, emoji) {
            widget.controller.text = emoji.emoji;
            Navigator.of(context).pop<void>();
          },
          onBackspacePressed: () {
            widget.controller.text = current;
          },
        );
      },
    );
    setState(() => _isActive = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.colorScheme.secondary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(context),
      child: SizedBox.square(
        dimension: 48.r,
        child: TweenAnimationBuilder<Color?>(
          duration: Durations.short2,
          tween: ColorTween(
            begin: secondary.withOpacity(0.0),
            end: secondary.withOpacity(_isActive ? 1.0 : 0.0),
          ),
          builder: (context, color, child) {
            // -> background
            return DecoratedBox(
              decoration: ShapeDecoration(
                color: theme.colorScheme.surfaceContainer,
                shape: SmoothRectangleBorder(
                  side: BorderSide(color: color!),
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(
                      cornerRadius: 15.r,
                      cornerSmoothing: 1.0,
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: ListenableBuilder(
                  listenable: widget.controller.controller,
                  builder: (context, child) {
                    // -> emoji
                    return Center(
                      child: Text(
                        widget.controller.text,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 30.sp,
                          height: .0,
                        ),
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
