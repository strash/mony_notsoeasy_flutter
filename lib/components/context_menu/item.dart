import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/gen/assets.gen.dart";

class ContextMenuItemComponent extends StatelessWidget {
  final Widget label;
  final Widget? icon;
  final bool? isActive;
  final VoidCallback onTap;

  const ContextMenuItemComponent({
    super.key,
    required this.label,
    this.icon,
    this.isActive,
    required this.onTap,
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
          padding: EdgeInsets.fromLTRB(
            isActive != null ? 10.0 : 20.0,
            12.0,
            16.0,
            12.0,
          ),
          child: SeparatedComponent.list(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            separatorBuilder: (context, index) => const SizedBox(width: 10.0),
            children: [
              Flexible(
                child: Row(
                  children: [
                    // -> check icon
                    if (isActive != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: SizedBox.square(
                          dimension: 26.0,
                          child:
                              isActive!
                                  ? SvgPicture.asset(
                                    Assets.icons.checkmark,
                                    width: 26.0,
                                    height: 26.0,
                                    colorFilter: ColorFilter.mode(
                                      theme.colorScheme.primary,
                                      BlendMode.srcIn,
                                    ),
                                  )
                                  : null,
                        ),
                      ),

                    // -> label
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: label,
                    ),
                  ],
                ),
              ),

              // -> icon
              if (icon != null) SizedBox.square(dimension: 26.0, child: icon),
            ],
          ),
        ),
      ),
    );
  }
}
