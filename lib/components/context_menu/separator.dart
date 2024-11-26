import "package:flutter/material.dart";

class ContextMenuSeparatorComponent extends StatelessWidget {
  final bool isBig;

  const ContextMenuSeparatorComponent({
    super.key,
    required this.isBig,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.colorScheme.outline.withOpacity(isBig ? .1 : .2),
      child: SizedBox.fromSize(
        size: Size.fromHeight(isBig ? 8.0 : 1.0),
      ),
    );
  }
}
