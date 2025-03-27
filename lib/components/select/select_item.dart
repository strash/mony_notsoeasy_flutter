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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? () => Navigator.of(context).maybePop<T>(value) : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            children: [
              // -> check icon
              if (equal(_SelectValueProvider.of<T>(context).value, value))
                SvgPicture.asset(
                  Assets.icons.checkmark,
                  width: 20.0,
                  height: 20.0,
                  colorFilter: ColorFilter.mode(
                    ColorScheme.of(context).secondary,
                    BlendMode.srcIn,
                  ),
                )
              else
                const SizedBox.square(dimension: 20.0),

              const SizedBox(width: 15.0),

              // -> child
              Flexible(
                child: DefaultTextStyle(
                  style: GoogleFonts.golosText(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: ColorScheme.of(context).onSurface,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
