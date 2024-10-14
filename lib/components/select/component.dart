import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/gen/assets.gen.dart";

export "./controller.dart";
part "./select_entry.dart";

class SelectComponent<T> extends StatefulWidget {
  final SelectController<T?> controller;
  final Widget? placeholder;
  final Widget? activeEntry;
  final List<SelectEntryComponent<T>> Function(BuildContext context)
      entryBuilder;

  const SelectComponent({
    super.key,
    required this.controller,
    this.placeholder,
    this.activeEntry,
    required this.entryBuilder,
  });

  @override
  State<SelectComponent<T>> createState() => _SelectComponentState<T>();
}

class _SelectComponentState<T> extends State<SelectComponent<T>> {
  bool _isActive = false;

  Future<void> _onTap(BuildContext context) async {
    setState(() => _isActive = true);
    final viewPaddings = MediaQuery.viewPaddingOf(context);
    final entries = widget.entryBuilder(context);
    final value = await BottomSheetComponent.show<T>(
      context,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: viewPaddings.bottom + 20.h),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return _EntryValueProvider<T>(
            controller: widget.controller,
            child: SizedBox(
              child: entries.elementAt(index),
            ),
          );
        },
      ),
    );
    if (value != null) widget.controller.value = value;
    setState(() => _isActive = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String placeholderText = "";
    if (widget.placeholder != null && widget.placeholder is Text) {
      placeholderText = (widget.placeholder! as Text).data ?? "";
    }
    final primary = theme.colorScheme.primary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(context),
      child: SizedBox.fromSize(
        size: Size.fromHeight(48.r),
        child: TweenAnimationBuilder<Color?>(
          duration: Durations.short2,
          tween: ColorTween(
            begin: primary.withOpacity(0.0),
            end: primary.withOpacity(_isActive ? 1.0 : 0.0),
          ),
          builder: (context, color, child) {
            return DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: color!),
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(
                    cornerRadius: 15.r,
                    cornerSmoothing: 1.0,
                  ),
                ),
                color: theme.colorScheme.surfaceContainer,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 15.w, right: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // -> placeholder
                    Flexible(
                      child: widget.activeEntry == null
                          ? Text(
                              placeholderText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.robotoFlex(
                                fontSize: 15.sp,
                                color: theme.colorScheme.onSurfaceVariant
                                    .withOpacity(0.4),
                              ),
                            )
                          : DefaultTextStyle(
                              style: GoogleFonts.robotoFlex(
                                fontSize: 15.sp,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              child: widget.activeEntry!,
                            ),
                    ),

                    // -> icon
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: SvgPicture.asset(
                        Assets.icons.chevronUpChevronDown,
                        width: 24.r,
                        height: 24.r,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final class _EntryValueProvider<T> extends InheritedWidget {
  final SelectController<T?> controller;

  const _EntryValueProvider({
    required super.child,
    required this.controller,
  });

  static SelectController<T?>? maybeOf<T>(BuildContext context) {
    final p =
        context.dependOnInheritedWidgetOfExactType<_EntryValueProvider<T>>();
    return p?.controller;
  }

  static SelectController<T?> of<T>(BuildContext context) {
    final result = maybeOf<T>(context);
    if (result == null) throw ArgumentError.value(context);
    return result;
  }

  @override
  bool updateShouldNotify(_EntryValueProvider<T> oldWidget) {
    return controller.value != oldWidget.controller.value;
  }
}
