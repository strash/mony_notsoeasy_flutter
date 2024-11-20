import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";

class AppBarButtonComponent extends StatelessWidget {
  final String icon;
  final Color color;
  final VoidCallback? onTap;

  const AppBarButtonComponent({
    super.key,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox.square(
        dimension: 50.r,
        child: Center(
          child: AnimatedOpacity(
            opacity: onTap != null ? 1.0 : .3,
            duration: Durations.short4,
            curve: Curves.easeInOut,
            child: SvgPicture.asset(
              icon,
              width: 28.r,
              height: 28.r,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
