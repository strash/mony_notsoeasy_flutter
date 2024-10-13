import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/gen/assets.gen.dart";

class SelectEntryComponent<T> extends StatelessWidget {
  final T value;
  final bool enabled;
  final bool selected;
  final Widget child;

  const SelectEntryComponent({
    super.key,
    required this.value,
    required this.enabled,
    required this.selected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? () => Navigator.of(context).maybePop<T>(value) : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // -> check icon
              if (selected)
                SvgPicture.asset(
                  Assets.icons.checkmark,
                  width: 20.r,
                  height: 20.r,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                )
              else
                SizedBox.square(dimension: 20.r),

              SizedBox(width: 15.w),

              // -> child
              Flexible(
                child: DefaultTextStyle(
                  style: GoogleFonts.robotoFlex(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
