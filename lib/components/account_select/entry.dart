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
    final ex = Theme.of(context).extension<ColorExtension>();
    final colorScheme = ColorScheme.of(context);
    final color = ex?.from(account.colorName).color ?? colorScheme.primary;

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
                        isColorsVisible ? color : colorScheme.surfaceContainer,
                    shape: Smooth.border(
                      14.0,
                      isColorsVisible
                          ? BorderSide.none
                          : BorderSide(color: colorScheme.outlineVariant),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      account.type.icon,
                      style: TextTheme.of(
                        context,
                      ).headlineSmall?.copyWith(height: .0),
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
                                    : colorScheme.onSurfaceVariant,
                            foreground: colorScheme.surface,
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
                                      : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // -> account type
                    Text(
                      context.t.models.account.type_description(
                        context: account.type,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style.copyWith(
                        fontSize: 14.0,
                        color: colorScheme.onSurfaceVariant,
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
