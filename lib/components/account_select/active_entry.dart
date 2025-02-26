part of "./component.dart";

class _AccountSelectActiveEntryComponent
    extends IAccountSelectActiveEntryComponent {
  const _AccountSelectActiveEntryComponent({
    required super.controller,
    required super.isColorsVisible,
  });

  @override
  Widget build(BuildContext context) {
    final value = controller.value;
    if (value == null) return const SizedBox();

    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final color = ex?.from(value.colorName).color ?? theme.colorScheme.primary;

    return Row(
      children: [
        // -> currency tag
        Padding(
          padding: const EdgeInsets.only(top: 2.0, right: 6.0),
          child: CurrencyTagComponent(
            code: value.currency.code,
            background:
                isColorsVisible ? color : theme.colorScheme.onSurfaceVariant,
            foreground: theme.colorScheme.surface,
          ),
        ),

        // -> title
        Flexible(
          child: Text(
            value.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DefaultTextStyle.of(context).style.copyWith(
              color: isColorsVisible ? color : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
