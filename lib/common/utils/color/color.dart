import "package:flutter/material.dart";

typedef TCategoryColors = ({Color bg, Color border, Color text});

TCategoryColors getCategoryColors(BuildContext context, Color color) {
  final theme = Theme.of(context);
  return (
    bg: Color.lerp(theme.colorScheme.surfaceContainer, color, .1)!,
    border: Color.lerp(theme.colorScheme.onSurface, color, .6)!.withOpacity(.8),
    text: Color.lerp(theme.colorScheme.onSurface, color, 0.3)!,
  );
}
