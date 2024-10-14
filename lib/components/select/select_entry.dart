part of "./component.dart";

class SelectEntryComponent<T> extends StatelessWidget {
  final T value;
  final bool enabled;
  final Widget child;

  const SelectEntryComponent({
    super.key,
    required this.value,
    this.enabled = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = _EntryValueProvider.of<T>(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? () => Navigator.of(context).maybePop<T>(value) : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
          child: ListenableBuilder(
            listenable: provider,
            child: Flexible(
              child: DefaultTextStyle(
                style: GoogleFonts.robotoFlex(
                  fontSize: 16.sp,
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
                  if (provider.value == value)
                    SvgPicture.asset(
                      Assets.icons.checkmark,
                      width: 20.r,
                      height: 20.r,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    )
                  else
                    SizedBox.square(dimension: 20.r),

                  SizedBox(width: 15.w),

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
