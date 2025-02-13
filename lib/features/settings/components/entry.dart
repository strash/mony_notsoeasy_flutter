import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class SettingsEntryComponent extends StatelessWidget {
  final Widget title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsEntryComponent({
    super.key,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 50.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // -> title
              DefaultTextStyle(
                style: GoogleFonts.golosText(
                  fontSize: 16.0,
                  color:
                      onTap != null
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                ),
                child: title,
              ),

              // -> trailing
              if (trailing != null)
                DefaultTextStyle(
                  style: GoogleFonts.golosText(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  child: trailing!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
