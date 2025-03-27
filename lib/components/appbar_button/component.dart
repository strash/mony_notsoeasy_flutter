import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/components/appbar/component.dart";

class AppBarButtonComponent extends StatelessWidget {
  final String icon;
  final Color? color;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const AppBarButtonComponent({
    super.key,
    required this.icon,
    this.color,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox.square(
        dimension: AppBarComponent.height,
        child: Center(
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: AnimatedOpacity(
              opacity: onTap != null ? 1.0 : .3,
              duration: Durations.short4,
              curve: Curves.easeInOut,
              child: SvgPicture.asset(
                icon,
                width: 28.0,
                height: 28.0,
                colorFilter: ColorFilter.mode(
                  color ?? ColorScheme.of(context).primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
