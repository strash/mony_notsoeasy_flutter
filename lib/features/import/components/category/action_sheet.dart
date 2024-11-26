import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/gen/assets.gen.dart";

enum EImportCategoryMenuAction implements IDescriptable {
  link,
  create,
  ;

  @override
  String get description => switch (this) {
        EImportCategoryMenuAction.link => "Привязать",
        EImportCategoryMenuAction.create => "Дополнить",
      };
}

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
                  Assets.icons.link,
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
            "Привязка категорий",
            style: GoogleFonts.golosText(
              fontSize: 20.0,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15.0),

          // -> description
          Text(
            "При привязке категории к одной из предустановленных, "
            "все транзакции, связанные с оригинальной категорией будут "
            "привязаны к предустановленной. Например, если у тебя была "
            'категория "Покупки из магазина", ты выберешь предустановленную '
            'категорию "Продукты", то после импорта категория будет '
            'называться "Продукты".\n\nЕсли не хочешь привязывать, можно '
            "оставить оригинальную категорию, но тогда ее нужно будет "
            "дополнить некоторыми данными.",
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
                  child: Text(item.description),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
