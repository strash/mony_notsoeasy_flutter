import "package:flutter/material.dart";

class ContextMenuSeparatorComponent extends StatelessWidget {
  final bool isBig;

  const ContextMenuSeparatorComponent({super.key, required this.isBig});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorScheme.of(context).outline.withValues(alpha: isBig ? .1 : .2),
      child: SizedBox.fromSize(size: Size.fromHeight(isBig ? 5.0 : 1.0)),
    );
  }
}
