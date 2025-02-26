part of "./component.dart";

class _AccountSelectEntryComponent extends StatelessWidget {
  final AccountModel account;
  final bool isColorsVisible;

  const _AccountSelectEntryComponent({
    required this.account,
    required this.isColorsVisible,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final color =
        ex?.from(account.colorName).color ?? theme.colorScheme.primary;

    return SelectEntryComponent<AccountModel>(
      value: account,
      equal: (lhs, rhs) => lhs != null && lhs.id == rhs.id,
      child: Builder(
        builder: (context) {
          final style = DefaultTextStyle.of(context).style;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -> icon
              SizedBox.square(
                dimension: 36.0,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color:
                        isColorsVisible
                            ? color
                            : theme.colorScheme.surfaceContainer,
                    shape: SmoothRectangleBorder(
                      side:
                          isColorsVisible
                              ? BorderSide.none
                              : BorderSide(
                                color: theme.colorScheme.outlineVariant,
                              ),
                      borderRadius: const SmoothBorderRadius.all(
                        SmoothRadius(cornerRadius: 14.0, cornerSmoothing: 0.6),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      account.type.icon,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        height: .0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 7.0),

              Flexible(
                child: SeparatedComponent.list(
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 1.0);
                  },
                  children: [
                    // -> title and currency symbol/code
                    Row(
                      children: [
                        // -> currency tag
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, right: 5.0),
                          child: CurrencyTagComponent(
                            code: account.currency.code,
                            background:
                                isColorsVisible
                                    ? color
                                    : theme.colorScheme.onSurfaceVariant,
                            foreground: theme.colorScheme.surface,
                          ),
                        ),

                        // -> title
                        Flexible(
                          child: Text(
                            account.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: style.copyWith(
                              fontWeight: FontWeight.w600,
                              color:
                                  isColorsVisible
                                      ? color
                                      : theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // -> account type
                    Text(
                      account.type.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style.copyWith(
                        fontSize: 14.0,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
