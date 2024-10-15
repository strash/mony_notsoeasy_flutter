import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/gen/assets.gen.dart";

part "./controller.dart";
part "./item.dart";
part "./provider.dart";

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
      child: _ValueProvider<T>(
        controller: widget.controller,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: viewPaddings.bottom + 20.h),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            return SizedBox(
              child: entries.elementAt(index),
            );
          },
        ),
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
    final accent = theme.colorScheme.secondary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(context),
      child: SizedBox.fromSize(
        size: Size.fromHeight(48.r),
        child: TweenAnimationBuilder<Color?>(
          duration: Durations.short2,
          tween: ColorTween(
            begin: accent.withOpacity(0.0),
            end: accent.withOpacity(_isActive ? 1.0 : 0.0),
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
                padding: EdgeInsets.only(left: 15.w, right: 7.w),
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
                        colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
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
