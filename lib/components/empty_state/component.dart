import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/gen/assets.gen.dart";

class EmptyStateComponent extends StatelessWidget {
  const EmptyStateComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // -> appbar
          const AppBarComponent(showBackground: false),

          // -> empty state
          SliverFillRemaining(
            child: SeparatedComponent.list(
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 10.0),
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // -> icon
                SvgPicture.asset(
                  Assets.icons.locationSlashFill,
                  width: 150.0,
                  height: 150.0,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.tertiaryContainer.withValues(alpha: .6),
                    BlendMode.srcIn,
                  ),
                ),

                // -> description
                Text(
                  "Такой страницы\nбольше не существует!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.golosText(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.tertiaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
