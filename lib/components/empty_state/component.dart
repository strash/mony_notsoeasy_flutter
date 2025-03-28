import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class EmptyStateComponent extends StatelessWidget {
  final Color color;

  const EmptyStateComponent({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SeparatedComponent.list(
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // -> icon
        SvgPicture.asset(
          Assets.icons.sparkles,
          width: 150.0,
          height: 150.0,
          colorFilter: ColorFilter.mode(
            color.withValues(alpha: .3),
            BlendMode.srcIn,
          ),
        ),

        // -> description
        Text(
          context.t.components.empty_state.description,
          textAlign: TextAlign.center,
          style: GoogleFonts.golosText(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: ColorScheme.of(context).tertiaryContainer,
          ),
        ),
      ],
    );
  }
}
