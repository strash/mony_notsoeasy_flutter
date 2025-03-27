import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/figma_squircle.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/gen/assets.gen.dart";

part "./select_controller.dart";
part "./select_item.dart";
part "./select_provider.dart";

class SelectComponent<T> extends StatefulWidget {
  final SelectController<T?> controller;
  final EdgeInsets? activeEntryPadding;
  final Widget? placeholder;
  final Widget? Function(SelectController<T?> controller) activeEntry;
  final bool expand;
  final List<SelectEntryComponent<T>> Function(BuildContext context)
  entryBuilder;

  const SelectComponent({
    super.key,
    required this.controller,
    this.activeEntryPadding,
    this.placeholder,
    required this.activeEntry,
    this.expand = false,
    required this.entryBuilder,
  });

  @override
  State<SelectComponent<T>> createState() => _SelectComponentState<T>();
}

class _SelectComponentState<T> extends State<SelectComponent<T>> {
  bool _isActive = false;

  Future<void> _onTap(BuildContext context) async {
    setState(() => _isActive = true);
    final entries = widget.entryBuilder(context);
    final value = await BottomSheetComponent.show<T>(
      context,
      builder: (context, bottom) {
        return _SelectValueProvider<T>(
          notifier: widget.controller,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 40.0 + bottom),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return entries.elementAt(index);
            },
          ),
        );
      },
    );
    if (value != null) widget.controller.value = value;
    setState(() => _isActive = false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(context),
      child: SizedBox.fromSize(
        size: const Size.fromHeight(48.0),
        child: _SelectValueProvider(
          notifier: widget.controller,
          child: TweenAnimationBuilder<Color?>(
            duration: Durations.short2,
            tween: ColorTween(
              begin: colorScheme.secondary.withValues(alpha: 0.0),
              end: colorScheme.secondary.withValues(
                alpha: _isActive ? 1.0 : 0.0,
              ),
            ),
            builder: (context, color, child) {
              final controller = _SelectValueProvider.of<T>(context);
              final entry = widget.activeEntry(controller);

              return DecoratedBox(
                decoration: ShapeDecoration(
                  color: colorScheme.surfaceContainer,
                  shape: Smooth.border(15.0, BorderSide(color: color!)),
                ),
                child: Padding(
                  padding:
                      (widget.activeEntryPadding != null && entry != null)
                          ? widget.activeEntryPadding!.copyWith(right: 5.0)
                          : const EdgeInsets.only(left: 15.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // -> placeholder
                      Flexible(
                        child:
                            entry == null
                                ? DefaultTextStyle(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.golosText(
                                    fontSize: 16.0,
                                    color: colorScheme.onSurfaceVariant
                                        .withValues(alpha: .6),
                                  ),
                                  child: widget.placeholder ?? const Text(""),
                                )
                                : DefaultTextStyle(
                                  style: GoogleFonts.golosText(
                                    fontSize: 16.0,
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  child: entry,
                                ),
                      ),

                      // -> icon
                      SvgPicture.asset(
                        Assets.icons.chevronUpChevronDown,
                        width: 24.0,
                        height: 24.0,
                        colorFilter: ColorFilter.mode(
                          colorScheme.secondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
