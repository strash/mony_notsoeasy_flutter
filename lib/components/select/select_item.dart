part of "./select.dart";

class SelectEntryComponent<T> extends StatelessWidget {
  final T value;
  final bool enabled;
  final bool Function(T? lhs, T rhs) equal;
  final Widget child;

  const SelectEntryComponent({
    super.key,
    required this.value,
    this.enabled = true,
    required this.equal,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = _SelectValueProvider.of<T>(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? () => Navigator.of(context).maybePop<T>(value) : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
          child: ListenableBuilder(
            listenable: provider,
            child: Flexible(
              child: DefaultTextStyle(
                style: GoogleFonts.golosText(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface,
                ),
                child: child,
              ),
            ),
            builder: (context, listenableChild) {
              return Row(
                children: [
                  // -> check icon
                  if (equal(provider.value, value))
                    SvgPicture.asset(
                      Assets.icons.checkmark,
                      width: 20.0,
                      height: 20.0,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.secondary,
                        BlendMode.srcIn,
                      ),
                    )
                  else
                    const SizedBox.square(dimension: 20.0),

                  const SizedBox(width: 15.0),

                  // -> child
                  listenableChild!,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
