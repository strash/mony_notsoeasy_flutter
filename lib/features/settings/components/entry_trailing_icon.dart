import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class SettingsEntryTrailingIconComponent extends StatelessWidget {
  final String icon;
  final Color color;

  const SettingsEntryTrailingIconComponent({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: SvgPicture.asset(
        icon,
        width: 26.0,
        height: 26.0,
        colorFilter: ColorFilter.mode(
          color,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
