import "package:flutter/material.dart";

class TransactionFormTagsGradientComponent extends StatelessWidget {
  final bool isVisible;
  final bool isLeft;

  const TransactionFormTagsGradientComponent({
    super.key,
    required this.isVisible,
    required this.isLeft,
  });

  List<Color> _getColors(BuildContext context) {
    final color = ColorScheme.of(context).surface;
    return isLeft
        ? [color, color.withValues(alpha: .0)]
        : [color.withValues(alpha: .0), color];
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : .0,
        duration: Durations.short4,
        child: SizedBox.fromSize(
          size: const Size.fromWidth(24.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: _getColors(context)),
            ),
          ),
        ),
      ),
    );
  }
}
