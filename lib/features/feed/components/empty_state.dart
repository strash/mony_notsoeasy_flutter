import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/gen/assets.gen.dart";

class FeedEmptyStateComponent extends StatelessWidget {
  const FeedEmptyStateComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SeparatedComponent.list(
      separatorBuilder: (context) => const SizedBox(height: 10.0),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // -> icon
        SvgPicture.asset(
          Assets.icons.sparkles,
          width: 150.0,
          height: 150.0,
          colorFilter: ColorFilter.mode(
            theme.colorScheme.surfaceContainer,
            BlendMode.srcIn,
          ),
        ),

        // -> description
        Text(
          "Тут ничего нет.\nЗаписывай траты!",
          textAlign: TextAlign.center,
          style: GoogleFonts.golosText(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(.4),
          ),
        ),
      ],
    );
  }
}
