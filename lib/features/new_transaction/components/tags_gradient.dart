import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

class NewTransactionTagsGradientComponent extends StatelessWidget {
  final bool isVisible;
  final bool isLeft;

  const NewTransactionTagsGradientComponent({
    super.key,
    required this.isVisible,
    required this.isLeft,
  });

  List<Color> _getColors(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.surface;
    return isLeft
        ? [color, color.withOpacity(.0)]
        : [color.withOpacity(.0), color];
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : .0,
        duration: Durations.short4,
        child: SizedBox.fromSize(
          size: Size.fromWidth(24.w),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getColors(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
