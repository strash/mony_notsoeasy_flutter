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
    final colorScheme = ColorScheme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 50.0),
        child: Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            right: trailing == null ? 15.0 : .0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // -> title
              DefaultTextStyle(
                style: GoogleFonts.golosText(
                  fontSize: 16.0,
                  color:
                      onTap != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                ),
                child: title,
              ),

              // -> trailing
              if (trailing != null)
                DefaultTextStyle(
                  style: GoogleFonts.golosText(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
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
