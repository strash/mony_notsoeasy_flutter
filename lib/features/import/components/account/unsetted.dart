import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class AccountUnsettedItemComponent extends StatelessWidget {
  final String? title;

  const AccountUnsettedItemComponent({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = this.title;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // -> title
          Flexible(
            child: Text(
              (title != null && title.isNotEmpty)
                  ? title
                  : context.t.features.import.map_accounts.account_placeholder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.golosText(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 10.0),

          // -> icon edit
          SvgPicture.asset(
            Assets.icons.plus,
            width: 24.0,
            height: 24.0,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.secondary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
