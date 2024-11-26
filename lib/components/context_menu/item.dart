import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";

class ContextMenuItemComponent extends StatelessWidget {
  final Widget label;
  final Widget? icon;
  final VoidCallback onTap;

  const ContextMenuItemComponent({
    super.key,
    required this.onTap,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTextStyle(
      style: GoogleFonts.golosText(
        textStyle: theme.textTheme.bodyMedium,
        fontSize: 17.0,
        decoration: TextDecoration.none,
        color: theme.colorScheme.onSurface,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 16.0, 12.0),
          child: SeparatedComponent.list(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            separatorBuilder: (context, index) => const SizedBox(width: 10.0),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // -> label
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: label,
                ),
              ),

              // -> icon
              if (icon != null)
                SizedBox.square(
                  dimension: 26.0,
                  child: icon,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
