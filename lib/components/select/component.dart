import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/gen/assets.gen.dart";

export "./select_entry.dart";

class SelectComponent<T> extends StatefulWidget {
  final Widget? placeholder;
  final Widget? activeEntry;
  final List<SelectEntryComponent<T>> Function(BuildContext context)
      entryBuilder;
  final void Function(T? selected) onSelect;

  const SelectComponent({
    super.key,
    this.placeholder,
    this.activeEntry,
    required this.entryBuilder,
    required this.onSelect,
  });

  @override
  State<SelectComponent<T>> createState() => _SelectComponentState<T>();
}

class _SelectComponentState<T> extends State<SelectComponent<T>> {
  bool _isActive = false;

  Future<void> _onTap(BuildContext context) async {
    setState(() => _isActive = true);
    final value = await BottomSheetComponent.show<T>(
      context,
      builder: (context) {
        return Column(children: widget.entryBuilder(context));
      },
    );
    setState(() => _isActive = false);
    if (context.mounted) {
      widget.onSelect(value);
    }
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
                    if (widget.activeEntry == null)
                      Text(
                        placeholderText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.robotoFlex(
                          fontSize: 15.sp,
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.4),
                        ),
                      )
                    else
                      widget.activeEntry!,

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
