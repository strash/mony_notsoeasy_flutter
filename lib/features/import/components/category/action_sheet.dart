import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

enum EImportCategoryMenuAction { link, create }

class ImportCategoryActionBottomSheetComponent extends StatelessWidget {
  const ImportCategoryActionBottomSheetComponent({super.key});

  void _pop(BuildContext context, EImportCategoryMenuAction action) {
    return Navigator.of(context).pop<EImportCategoryMenuAction>(action);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: MediaQuery.viewPaddingOf(context).bottom + 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -> icon
          const Spacer(),
          Center(
            child: Stack(
              children: [
                SvgPicture.asset(
                  Assets.icons.linkForBadge,
                  width: 100.0,
                  height: 100.0,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.tertiaryContainer,
                    BlendMode.srcIn,
                  ),
                ),
                SvgPicture.asset(
                  Assets.icons.linkBadgePlus,
                  width: 100.0,
                  height: 100.0,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.secondary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // -> title
          Text(
            context.t.features.import.map_categories.action_sheet.title,
            style: GoogleFonts.golosText(
              fontSize: 20.0,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15.0),

          // -> description
          Text(
            context.t.features.import.map_categories.action_sheet.description,
            style: GoogleFonts.golosText(
              fontSize: 15.0,
              height: 1.3,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 40.0),

          // -> actions
          SeparatedComponent.builder(
            direction: Axis.horizontal,
            itemCount: EImportCategoryMenuAction.values.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10.0),
            itemBuilder: (context, index) {
              final item = EImportCategoryMenuAction.values.elementAt(index);

              return Expanded(
                child: FilledButton(
                  onPressed: () => _pop(context, item),
                  child: Text(
                    context.t.features.import.map_categories.action_sheet
                        .menu_item(context: item),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
